import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:elxau/demo_config.dart';
import 'package:elxau/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final bool isFirebaseInitialized;
  late final fb_auth.FirebaseAuth? _fbAuth;
  late final FirebaseFirestore? _db;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _authToken;

  // Stream controller for mock auth state
  final StreamController<fb_auth.User?> _mockAuthStreamController = StreamController<fb_auth.User?>.broadcast();

  AuthService({required this.isFirebaseInitialized}) {
    if (isFirebaseInitialized) {
      _fbAuth = fb_auth.FirebaseAuth.instance;
      _db = FirebaseFirestore.instance;
    } else {
      _fbAuth = null;
      _db = null;
    }
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get authToken => _authToken;

  // Stream pour l'état d'auth
  Stream<fb_auth.User?> get userStream => 
      isFirebaseInitialized ? _fbAuth!.authStateChanges() : _mockAuthStreamController.stream;

  // Initialiser le service
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (isFirebaseInitialized) {
        // Écouter les changements d'état d'authentification
        _fbAuth!.authStateChanges().listen((fb_auth.User? user) async {
          if (user != null) {
            // Récupérer les données utilisateur depuis Firestore
            await _loadUserData(user.uid);
          } else if (DemoConfig.demoAuthEnabled &&
              _currentUser?.id.startsWith('mock_') == true) {
            // Conserver la session demo locale en debug uniquement
          } else {
            _currentUser = null;
            _authToken = null;
          }
          _isLoading = false;
          notifyListeners();
        });
      } else {
        // Mode Mock: on assume qu'on n'est pas connecté au démarrage
        _currentUser = null;
        _authToken = null;
        _mockAuthStreamController.add(null);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur init AuthService: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger les données utilisateur depuis Firestore
  Future<void> _loadUserData(String uid) async {
    if (!isFirebaseInitialized) return;
    try {
      final doc = await _db!.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = User.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('Erreur chargement données utilisateur: $e');
    }
  }

  // Connexion
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (!isFirebaseInitialized) {
        if (!DemoConfig.demoAuthEnabled) {
          return _unavailable('Service de connexion indisponible.');
        }
        return await _mockSignIn(email: email, asEntity: false);
      }

      final credential = await _fbAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData(credential.user!.uid);
        // Si le profil Firestore n'existe pas encore, créer un profil basique
        _currentUser ??= User(
          id: credential.user!.uid,
          email: email,
          nom: 'Utilisateur',
          dateInscription: DateTime.now(),
        );
        _isLoading = false;
        notifyListeners();
        return {
          'success': true,
          'message': 'Connexion réussie',
          'user': _currentUser,
        };
      }

      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Une erreur inconnue est survenue',
      };
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': _authErrorMessage(e),
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Connexion dédiée à l'espace entité (Firebase ; demo debug uniquement).
  Future<Map<String, dynamic>> signInEntityWorkspace({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    if (!isFirebaseInitialized) {
      if (!DemoConfig.demoAuthEnabled) {
        return _unavailable('Service de connexion indisponible.');
      }
      return _mockSignIn(email: email, asEntity: true);
    }

    try {
      final credential = await _fbAuth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData(credential.user!.uid);
        final uid = credential.user!.uid;

        if (_currentUser == null) {
          // Profil Firestore manquant : refusé en prod, demo uniquement en debug
          if (!DemoConfig.demoAuthEnabled) {
            await signOut();
            return _fail(
              'Compte entité incomplet. Contactez le support ImmoTrust.',
            );
          }
          _currentUser = User(
            id: uid,
            email: email,
            nom: 'Entité',
            isEntity: true,
            entityName: 'ImmoTrust Entité',
            dateInscription: DateTime.now(),
          );
        } else if (!_currentUser!.isEntity) {
          if (!DemoConfig.demoAuthEnabled) {
            await signOut();
            return _fail('Accès réservé aux comptes entité ImmoTrust.');
          }
          // Debug : accès workspace même sans flag Firestore
          _currentUser = _currentUser!.copyWith(
            isEntity: true,
            entityName: _currentUser!.entityName ?? 'ImmoTrust Entité',
          );
        }

        _isLoading = false;
        notifyListeners();
        return {
          'success': true,
          'message': 'Connexion réussie',
          'user': _currentUser,
        };
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      if (DemoConfig.demoAuthEnabled) {
        debugPrint(
            'Firebase auth échoué ($e) — fallback demo entité (debug)');
        return _mockSignIn(email: email, asEntity: true);
      }
      return _fail(_authErrorMessage(e));
    } catch (e) {
      if (DemoConfig.demoAuthEnabled) {
        debugPrint('Erreur auth entité ($e) — fallback demo');
        return _mockSignIn(email: email, asEntity: true);
      }
      return _fail('Erreur: ${e.toString()}');
    }

    return _fail('Une erreur inconnue est survenue');
  }

  Future<Map<String, dynamic>> _mockSignIn({
    required String email,
    required bool asEntity,
  }) async {
    assert(DemoConfig.demoAuthEnabled, 'Mock auth interdit hors debug');
    if (!DemoConfig.demoAuthEnabled) {
      return _unavailable('Service de connexion indisponible.');
    }

    await Future.delayed(const Duration(milliseconds: 600));
    final isEntityDemo = asEntity ||
        email.toLowerCase().contains('admin') ||
        email.toLowerCase().contains('entity') ||
        email.toLowerCase().contains('immotrust');
    _currentUser = User(
      id: 'mock_entity_id',
      email: email,
      nom: isEntityDemo ? 'Entité' : 'Utilisateur',
      prenom: 'Test',
      isPremium: true,
      dateInscription: DateTime.now(),
      isEntity: isEntityDemo,
      entityName: isEntityDemo ? 'ImmoTrust Entité' : null,
    );
    _isLoading = false;
    notifyListeners();
    return {
      'success': true,
      'message': isEntityDemo
          ? 'Connexion demo entité'
          : 'Connexion réussie (Mock)',
      'user': _currentUser,
    };
  }

  Map<String, dynamic> _fail(String message) {
    _isLoading = false;
    notifyListeners();
    return {'success': false, 'message': message};
  }

  Map<String, dynamic> _unavailable(String message) {
    return _fail(message);
  }

  String _authErrorMessage(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé pour cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'invalid-email':
        return 'Format d\'email invalide';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Email ou mot de passe incorrect';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      default:
        return e.message ?? 'Erreur de connexion';
    }
  }

  // Inscription
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String nom,
    String? prenom,
    String? telephone,
    bool isEntity = false,
    String? entityName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (!isFirebaseInitialized) {
        if (!DemoConfig.demoAuthEnabled) {
          return _unavailable('Service d\'inscription indisponible.');
        }
        await Future.delayed(const Duration(seconds: 1));
        _currentUser = User(
          id: 'mock_user_id',
          email: email,
          nom: nom,
          prenom: prenom,
          telephone: telephone,
          isPremium: false,
          dateInscription: DateTime.now(),
          isEntity: isEntity,
          entityName: entityName,
        );
        _isLoading = false;
        notifyListeners();
        return {
          'success': true,
          'message': 'Inscription réussie (Mock)',
          'user': _currentUser,
        };
      }

      final credential = await _fbAuth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Créer l'utilisateur dans Firestore
        final newUser = User(
          id: credential.user!.uid,
          email: email,
          nom: nom,
          prenom: prenom,
          telephone: telephone,
          isPremium: false,
          dateInscription: DateTime.now(),
          isEntity: isEntity,
          entityName: entityName,
        );

        await _db!.collection('users').doc(newUser.id).set(newUser.toJson());
        
        _currentUser = newUser;
        
        _isLoading = false;
        notifyListeners();
        return {
          'success': true,
          'message': 'Inscription réussie',
          'user': _currentUser,
        };
      }

      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Erreur lors de la création du compte',
      };
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      String message = 'Erreur d\'inscription';
      if (e.code == 'email-already-in-use') {
        message = 'Cet email est déjà utilisé';
      } else if (e.code == 'weak-password') {
        message = 'Le mot de passe est trop faible';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  // Réinitialiser le mot de passe
  Future<Map<String, dynamic>> resetPassword({
    required String email,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (!isFirebaseInitialized) {
        if (!DemoConfig.demoAuthEnabled) {
          return _unavailable(
            'Réinitialisation indisponible. Vérifiez votre connexion.',
          );
        }
        await Future.delayed(const Duration(seconds: 1));
        _isLoading = false;
        notifyListeners();
        return {
          'success': true,
          'message': 'Un email de réinitialisation a été envoyé (Mock)',
        };
      }
      
      await _fbAuth!.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return {
        'success': true,
        'message': 'Un email de réinitialisation a été envoyé',
      };
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': e.message ?? 'Erreur lors de l\'envoi de l\'email',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    if (isFirebaseInitialized) {
      await _fbAuth!.signOut();
    } else {
      _mockAuthStreamController.add(null);
    }
    _currentUser = null;
    _authToken = null;
    notifyListeners();
  }

  // Mettre à jour le profil
  Future<Map<String, dynamic>> updateProfile({
    String? nom,
    String? prenom,
    String? telephone,
    bool? isEntity,
    String? entityName,
  }) async {
    if (_currentUser == null) {
      return {
        'success': false,
        'message': 'Utilisateur non connecté',
      };
    }

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        nom: nom ?? _currentUser!.nom,
        prenom: prenom ?? _currentUser!.prenom,
        telephone: telephone ?? _currentUser!.telephone,
        isEntity: isEntity ?? _currentUser!.isEntity,
        entityName: entityName ?? _currentUser!.entityName,
      );

      if (isFirebaseInitialized) {
        // Mettre à jour Firestore
        await _db!.collection('users').doc(_currentUser!.id).update(updatedUser.toJson());
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      _currentUser = updatedUser;

      _isLoading = false;
      notifyListeners();
      return {
        'success': true,
        'message': 'Profil mis à jour',
        'user': _currentUser,
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  /// Suppression du compte (exigence Play Store : permettre de supprimer le compte).
  Future<Map<String, dynamic>> deleteAccount() async {
    if (_currentUser == null) {
      return {'success': false, 'message': 'Utilisateur non connecté'};
    }

    _isLoading = true;
    notifyListeners();

    try {
      final uid = _currentUser!.id;
      final isMock = uid.startsWith('mock_');

      if (isFirebaseInitialized && !isMock) {
        try {
          await _db!.collection('users').doc(uid).delete();
        } catch (e) {
          debugPrint('Suppression Firestore users/$uid: $e');
        }

        final fbUser = _fbAuth!.currentUser;
        if (fbUser == null) {
          _isLoading = false;
          notifyListeners();
          return {
            'success': false,
            'message':
                'Session expiree. Reconnectez-vous puis reessayez la suppression.',
          };
        }
        await fbUser.delete();
      }

      _currentUser = null;
      _authToken = null;
      if (!isFirebaseInitialized || isMock) {
        _mockAuthStreamController.add(null);
      }

      _isLoading = false;
      notifyListeners();
      return {
        'success': true,
        'message': 'Compte supprime',
      };
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      if (e.code == 'requires-recent-login') {
        return {
          'success': false,
          'message':
              'Pour des raisons de securite, reconnectez-vous puis supprimez a nouveau votre compte.',
        };
      }
      return {
        'success': false,
        'message': e.message ?? 'Impossible de supprimer le compte',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
      };
    }
  }

  // Vérifier la validité du token
  Future<bool> validateToken() async {
    if (!isFirebaseInitialized) return isAuthenticated;
    final user = _fbAuth!.currentUser;
    return user != null;
  }
}
