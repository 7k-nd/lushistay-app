// ============================================================
// MODÈLE IMMOBILIER - ImmoTrust
// Supports: Hôtel, Maison, Appartement, Terrain
// ============================================================

import 'package:flutter/cupertino.dart';

enum PropertyType { hotel, house, apartment, land }

enum PropertyStatus { available, reserved, rented, sold }

enum ListingPurpose { sale, rent }

extension ListingPurposeExt on ListingPurpose {
  String get label {
    switch (this) {
      case ListingPurpose.sale:
        return 'À vendre';
      case ListingPurpose.rent:
        return 'À louer';
    }
  }
}

enum DurationType { days, months }

enum LegalStatus {
  titreFoncier,
  certificatEnregistrement,
  contratDeBail,
  unknown
}

extension LegalStatusExt on LegalStatus {
  String get label {
    switch (this) {
      case LegalStatus.titreFoncier:
        return 'Titre foncier';
      case LegalStatus.certificatEnregistrement:
        return 'Certificat d\'enregistrement';
      case LegalStatus.contratDeBail:
        return 'Contrat de bail';
      case LegalStatus.unknown:
        return 'Non spécifié';
    }
  }
}

extension PropertyTypeExt on PropertyType {
  String get label {
    switch (this) {
      case PropertyType.hotel:
        return 'Hôtel';
      case PropertyType.house:
        return 'Maison';
      case PropertyType.apartment:
        return 'Appartement';
      case PropertyType.land:
        return 'Terrain';
    }
  }

  IconData get icon {
    switch (this) {
      case PropertyType.hotel:
        return CupertinoIcons.bed_double_fill;
      case PropertyType.house:
        return CupertinoIcons.house_fill;
      case PropertyType.apartment:
        return CupertinoIcons.building_2_fill;
      case PropertyType.land:
        return CupertinoIcons.map_fill;
    }
  }
}

class PropertyFeatures {
  final int? bedrooms;
  final int? bathrooms;
  final double? surfaceM2;
  final bool? hasParking;
  final bool? hasGarden;
  final bool? hasPool;
  final bool? hasSecurity;
  final bool? hasWater;
  final bool? hasElectricity;
  final bool? hasFurnished;
  final bool? hasBalcony;
  final bool? hasAirConditioning;
  final bool? hasInternet;
  final String? landTitle; // Titre foncier pour terrains
  final bool? isViabilized; // Terrain viabilisé

  const PropertyFeatures({
    this.bedrooms,
    this.bathrooms,
    this.surfaceM2,
    this.hasParking,
    this.hasGarden,
    this.hasPool,
    this.hasSecurity,
    this.hasWater,
    this.hasElectricity,
    this.hasFurnished,
    this.hasBalcony,
    this.hasAirConditioning,
    this.hasInternet,
    this.landTitle,
    this.isViabilized,
  });

  Map<String, dynamic> toMap() => {
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'surfaceM2': surfaceM2,
        'hasParking': hasParking,
        'hasGarden': hasGarden,
        'hasPool': hasPool,
        'hasSecurity': hasSecurity,
        'hasWater': hasWater,
        'hasElectricity': hasElectricity,
        'hasFurnished': hasFurnished,
        'hasBalcony': hasBalcony,
        'hasAirConditioning': hasAirConditioning,
        'hasInternet': hasInternet,
        'landTitle': landTitle,
        'isViabilized': isViabilized,
      };

  factory PropertyFeatures.fromMap(Map<String, dynamic> data) =>
      PropertyFeatures(
        bedrooms: data['bedrooms'],
        bathrooms: data['bathrooms'],
        surfaceM2: (data['surfaceM2'] ?? 0.0).toDouble(),
        hasParking: data['hasParking'],
        hasGarden: data['hasGarden'],
        hasPool: data['hasPool'],
        hasSecurity: data['hasSecurity'],
        hasWater: data['hasWater'],
        hasElectricity: data['hasElectricity'],
        hasFurnished: data['hasFurnished'],
        hasBalcony: data['hasBalcony'],
        hasAirConditioning: data['hasAirConditioning'],
        hasInternet: data['hasInternet'],
        landTitle: data['landTitle'],
        isViabilized: data['isViabilized'],
      );
}

class Property {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final LegalStatus legalStatus;
  final String title;
  final String description;
  final PropertyType type;
  final PropertyStatus status;
  final ListingPurpose purpose;
  final String quartier; // Quartier/Commune
  final String commune;
  final String ville;
  final String fullAddress;
  final double pricePerDay;
  final double pricePerMonth;
  final double? priceSale;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final PropertyFeatures features;
  final List<String> tags;
  final DateTime createdAt;
  final bool isVerified;
  final int viewsCount;
  final int whatsappContactCount;
  final double? latitude;
  final double? longitude;

  const Property({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    this.legalStatus = LegalStatus.unknown,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    this.purpose = ListingPurpose.rent,
    required this.quartier,
    required this.commune,
    required this.ville,
    required this.fullAddress,
    required this.pricePerDay,
    required this.pricePerMonth,
    this.priceSale,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.features,
    required this.tags,
    required this.createdAt,
    required this.isVerified,
    this.viewsCount = 0,
    this.whatsappContactCount = 0,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() => {
        'ownerId': ownerId,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'legalStatus': legalStatus.name,
        'title': title,
        'description': description,
        'type': type.name,
        'status': status.name,
        'purpose': purpose.name,
        'quartier': quartier,
        'commune': commune,
        'ville': ville,
        'fullAddress': fullAddress,
        'pricePerDay': pricePerDay,
        'pricePerMonth': pricePerMonth,
        'priceSale': priceSale,
        'images': images,
        'rating': rating,
        'reviewCount': reviewCount,
        'features': features.toMap(),
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'isVerified': isVerified,
        'viewsCount': viewsCount,
        'whatsappContactCount': whatsappContactCount,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory Property.fromMap(String id, Map<String, dynamic> data) => Property(
        id: id,
        ownerId: data['ownerId'] ?? '',
        ownerName: data['ownerName'] ?? '',
        ownerPhone: data['ownerPhone'] ?? '',
        legalStatus: LegalStatus.values.firstWhere(
          (e) => e.name == data['legalStatus'],
          orElse: () => LegalStatus.unknown,
        ),
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        type: PropertyType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => PropertyType.house,
        ),
        status: PropertyStatus.values.firstWhere(
          (e) => e.name == data['status'],
          orElse: () => PropertyStatus.available,
        ),
        purpose: ListingPurpose.values.firstWhere(
          (e) => e.name == data['purpose'],
          orElse: () => ListingPurpose.rent,
        ),
        quartier: data['quartier'] ?? '',
        commune: data['commune'] ?? '',
        ville: data['ville'] ?? 'Lubumbashi',
        fullAddress: data['fullAddress'] ?? '',
        pricePerDay: (data['pricePerDay'] ?? 0.0).toDouble(),
        pricePerMonth: (data['pricePerMonth'] ?? 0.0).toDouble(),
        priceSale: (data['priceSale'] as num?)?.toDouble(),
        images: List<String>.from(data['images'] ?? []),
        rating: (data['rating'] ?? 0.0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
        features: PropertyFeatures.fromMap(
          Map<String, dynamic>.from(data['features'] ?? {}),
        ),
        tags: List<String>.from(data['tags'] ?? []),
        createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        isVerified: data['isVerified'] ?? false,
        viewsCount: data['viewsCount'] ?? 0,
        whatsappContactCount: data['whatsappContactCount'] ?? 0,
        latitude: (data['latitude'] as num?)?.toDouble(),
        longitude: (data['longitude'] as num?)?.toDouble(),
      );
}

// ============================================================
// MODÈLE DE RÉSERVATION IMMOBILIÈRE
// ============================================================
class PropertyBooking {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final Property property;
  final DateTime startDate;
  final DateTime endDate;
  final DurationType durationType;
  final int durationValue; // Nombre de jours ou mois
  final double totalPrice;
  final String paymentMethod;
  final String paymentStatus; // pending, paid, failed
  final String bookingStatus; // upcoming, active, completed, cancelled
  final DateTime createdAt;

  const PropertyBooking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.property,
    required this.startDate,
    required this.endDate,
    required this.durationType,
    required this.durationValue,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'userPhone': userPhone,
        'propertyId': property.id,
        'propertyTitle': property.title,
        'propertyImage': property.images.isNotEmpty ? property.images[0] : '',
        'propertyType': property.type.name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'durationType': durationType.name,
        'durationValue': durationValue,
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'bookingStatus': bookingStatus,
        'createdAt': createdAt.toIso8601String(),
      };
}

