import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elxau/models/property.dart';
import 'package:elxau/models/notification.dart';
import 'package:elxau/data/mock_data.dart';
import 'package:elxau/demo_config.dart';

class FirestoreService {
  final bool isFirebaseInitialized;
  late final FirebaseFirestore? _db;

  FirestoreService({required this.isFirebaseInitialized}) {
    if (isFirebaseInitialized) {
      _db = FirebaseFirestore.instance;
    } else {
      _db = null;
    }
  }

  bool get _useLocalDemo => !isFirebaseInitialized && DemoConfig.demoDataEnabled;

  Future<String> createProperty(Property property) async {
    if (!isFirebaseInitialized) {
      if (!DemoConfig.demoDataEnabled) {
        throw StateError(
          'Publication impossible : backend indisponible.',
        );
      }
      await Future.delayed(const Duration(milliseconds: 600));
      final id = 'local_${DateTime.now().millisecondsSinceEpoch}';
      MockProperties.properties.insert(
        0,
        Property(
          id: id,
          ownerId: property.ownerId,
          ownerName: property.ownerName,
          ownerPhone: property.ownerPhone,
          legalStatus: property.legalStatus,
          title: property.title,
          description: property.description,
          type: property.type,
          status: property.status,
          quartier: property.quartier,
          commune: property.commune,
          ville: property.ville,
          fullAddress: property.fullAddress,
          pricePerDay: property.pricePerDay,
          pricePerMonth: property.pricePerMonth,
          images: property.images,
          rating: property.rating,
          reviewCount: property.reviewCount,
          features: property.features,
          tags: property.tags,
          createdAt: property.createdAt,
          isVerified: property.isVerified,
          purpose: property.purpose,
          priceSale: property.priceSale,
          viewsCount: property.viewsCount,
          whatsappContactCount: property.whatsappContactCount,
          latitude: property.latitude,
          longitude: property.longitude,
        ),
      );
      return id;
    }

    final doc = await _db!.collection('properties').add(property.toMap());
    return doc.id;
  }

  Stream<List<Property>> getProperties() {
    if (!isFirebaseInitialized) {
      return Stream.value(List<Property>.from(MockProperties.properties));
    }

    try {
      return _db!.collection('properties').snapshots().map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return List<Property>.from(MockProperties.properties);
        }
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Property.fromMap(doc.id, data);
        }).toList();
      }).handleError((error) {
        return List<Property>.from(MockProperties.properties);
      });
    } catch (_) {
      return Stream.value(List<Property>.from(MockProperties.properties));
    }
  }

  Stream<Property> getProperty(String propertyId) {
    if (!isFirebaseInitialized) {
      if (!_useLocalDemo || MockProperties.properties.isEmpty) {
        return Stream.error(
          StateError('Bien introuvable (backend indisponible).'),
        );
      }
      final property = MockProperties.properties.firstWhere(
        (p) => p.id == propertyId,
        orElse: () => MockProperties.properties.first,
      );
      return Stream.value(property);
    }

    return _db!.collection('properties').doc(propertyId).snapshots().map((doc) {
      final data = doc.data()!;
      return Property.fromMap(doc.id, data);
    });
  }

  Stream<List<PropertyBooking>> getUserBookings(String userId) {
    if (!isFirebaseInitialized) {
      if (_useLocalDemo) {
        return Stream.value(MockData.bookings);
      }
      return Stream.value(const <PropertyBooking>[]);
    }

    return _db!
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return _mapDataToBooking(doc.id, data);
      }).toList();
    });
  }

  Stream<List<Property>> getOwnerProperties(String ownerId) {
    if (!isFirebaseInitialized || ownerId.isEmpty) {
      return Stream.value(const <Property>[]);
    }

    return _db!
        .collection('properties')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Property.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Notifications de l'espace entité (pas de faux contenu local).
  Stream<List<NotificationModel>> getEntityNotifications(String ownerId) {
    if (!isFirebaseInitialized || ownerId.isEmpty) {
      return Stream.value(const <NotificationModel>[]);
    }

    return _db!
        .collection('notifications')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
          .toList();
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    });
  }

  Future<void> markNotificationRead(String notificationId) async {
    if (!isFirebaseInitialized) return;
    await _db!
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllEntityNotificationsRead(String ownerId) async {
    if (!isFirebaseInitialized) return;
    final snap = await _db!
        .collection('notifications')
        .where('ownerId', isEqualTo: ownerId)
        .where('isRead', isEqualTo: false)
        .get();
    final batch = _db!.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> createEntityNotification(NotificationModel notification) async {
    if (!isFirebaseInitialized) return;
    await _db!.collection('notifications').add(notification.toMap());
  }

  /// Enregistre un contact WhatsApp et notifie l'entité propriétaire du bien.
  ///
  /// Effectue deux écritures Firestore en batch :
  ///  1. /whatsapp_contacts — trace du prospect
  ///  2. /notifications    — notification pour le dashboard entité
  Future<void> createWhatsAppContact({
    required String ownerId,
    required String propertyId,
    required String propertyTitle,
    required String userName,
    required String userPhone,
    String? userId,
  }) async {
    if (!isFirebaseInitialized) return;

    final now = DateTime.now();
    final batch = _db!.batch();

    // 1. Contact WhatsApp
    final contactRef = _db!.collection('whatsapp_contacts').doc();
    batch.set(contactRef, {
      'ownerId': ownerId,
      'propertyId': propertyId,
      'property': propertyTitle,
      'name': userName,
      'phone': userPhone,
      'userId': userId ?? '',
      'date': '${now.day.toString().padLeft(2, '0')}/'
          '${now.month.toString().padLeft(2, '0')}/${now.year}',
      'createdAt': now.toIso8601String(),
    });

    // 2. Notification entité
    final notifRef = _db!.collection('notifications').doc();
    batch.set(notifRef, {
      'ownerId': ownerId,
      'title': 'Nouveau contact WhatsApp',
      'message': '$userName s\'intéresse à "$propertyTitle".',
      'type': 'whatsapp',
      'isRead': false,
      'timestamp': now.toIso8601String(),
    });

    await batch.commit();
  }

  /// Contacts WhatsApp liés à l'entité (vide tant qu'aucun événement réel).
  Stream<List<Map<String, dynamic>>> getEntityWhatsAppContacts(String ownerId) {
    if (!isFirebaseInitialized || ownerId.isEmpty) {
      return Stream.value(const <Map<String, dynamic>>[]);
    }

    return _db!
        .collection('whatsapp_contacts')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? '',
          'phone': data['phone'] ?? '',
          'property': data['property'] ?? '',
          'date': data['date'] ?? '',
          'message': data['message'] ?? '',
          'createdAt': data['createdAt']?.toString() ?? '',
        };
      }).toList();
      list.sort((a, b) =>
          (b['createdAt'] as String).compareTo(a['createdAt'] as String));
      return list;
    });
  }

  Future<void> createBooking(String userId, PropertyBooking booking) async {
    if (!isFirebaseInitialized) {
      if (!DemoConfig.demoDataEnabled) {
        throw StateError('Réservation impossible : backend indisponible.');
      }
      await Future.delayed(const Duration(seconds: 1));
      MockData.bookings.add(booking);
      return;
    }

    final bookingData = booking.toMap();
    await _db!.collection('bookings').add(bookingData);
  }

  PropertyBooking _mapDataToBooking(String id, Map<String, dynamic> data) {
    return PropertyBooking(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      property: Property(
        id: data['propertyId'] ?? '',
        ownerId: '',
        ownerName: '',
        ownerPhone: '',
        title: data['propertyTitle'] ?? '',
        description: '',
        type: PropertyType.values.firstWhere(
          (e) => e.name == data['propertyType'],
          orElse: () => PropertyType.house,
        ),
        status: PropertyStatus.available,
        quartier: '',
        commune: '',
        ville: '',
        fullAddress: '',
        pricePerDay: 0,
        pricePerMonth: 0,
        images: [data['propertyImage'] ?? ''],
        rating: 0,
        reviewCount: 0,
        features: const PropertyFeatures(),
        tags: [],
        createdAt: DateTime.now(),
        isVerified: false,
      ),
      startDate: DateTime.tryParse(data['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(data['endDate'] ?? '') ?? DateTime.now(),
      durationType: DurationType.values.firstWhere(
        (e) => e.name == data['durationType'],
        orElse: () => DurationType.days,
      ),
      durationValue: data['durationValue'] ?? 1,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      paymentStatus: data['paymentStatus'] ?? '',
      bookingStatus: data['bookingStatus'] ?? '',
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
