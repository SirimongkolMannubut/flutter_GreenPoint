class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? profileImagePath;
  final int totalPoints;
  final int plasticReduced;
  final int level;
  final DateTime joinDate;
  final List<String> achievements;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.profileImagePath,
    required this.totalPoints,
    required this.plasticReduced,
    required this.level,
    required this.joinDate,
    required this.achievements,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      profileImagePath: json['profileImagePath'],
      totalPoints: json['totalPoints'],
      plasticReduced: json['plasticReduced'],
      level: json['level'],
      joinDate: DateTime.parse(json['joinDate']),
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'profileImagePath': profileImagePath,
      'totalPoints': totalPoints,
      'plasticReduced': plasticReduced,
      'level': level,
      'joinDate': joinDate.toIso8601String(),
      'achievements': achievements,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? profileImagePath,
    int? totalPoints,
    int? plasticReduced,
    int? level,
    DateTime? joinDate,
    List<String>? achievements,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      totalPoints: totalPoints ?? this.totalPoints,
      plasticReduced: plasticReduced ?? this.plasticReduced,
      level: level ?? this.level,
      joinDate: joinDate ?? this.joinDate,
      achievements: achievements ?? this.achievements,
    );
  }
}