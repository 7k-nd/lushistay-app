class User {
  final String id;
  final String email;
  final String nom;
  final String? prenom;
  final String? telephone;
  final String? photoUrl;
  final bool isPremium;
  final DateTime? dateInscription;
  final bool isEntity;
  final String? entityName;

  User({
    required this.id,
    required this.email,
    required this.nom,
    this.prenom,
    this.telephone,
    this.photoUrl,
    this.isPremium = false,
    this.dateInscription,
    this.isEntity = false,
    this.entityName,
  });

  String get name => nomComplet;

  // Méthode pour obtenir le nom complet ou le nom de l'entité
  String get nomComplet {
    if (isEntity && entityName != null && entityName!.isNotEmpty) {
      return entityName!;
    }
    if (prenom != null && prenom!.isNotEmpty) {
      return '$prenom $nom';
    }
    return nom;
  }

  // Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'dateInscription': dateInscription?.toIso8601String(),
      'isEntity': isEntity,
      'entityName': entityName,
    };
  }

  // Créer depuis JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'],
      telephone: json['telephone'],
      photoUrl: json['photoUrl'],
      isPremium: json['isPremium'] ?? false,
      dateInscription: json['dateInscription'] != null
          ? DateTime.parse(json['dateInscription'])
          : null,
      isEntity: json['isEntity'] ?? false,
      entityName: json['entityName'],
    );
  }

  // Copie avec modifications
  User copyWith({
    String? id,
    String? email,
    String? nom,
    String? prenom,
    String? telephone,
    String? photoUrl,
    bool? isPremium,
    DateTime? dateInscription,
    bool? isEntity,
    String? entityName,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      photoUrl: photoUrl ?? this.photoUrl,
      isPremium: isPremium ?? this.isPremium,
      dateInscription: dateInscription ?? this.dateInscription,
      isEntity: isEntity ?? this.isEntity,
      entityName: entityName ?? this.entityName,
    );
  }
}
