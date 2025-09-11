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
    try {
      return User(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        profileImage: json['profileImage']?.toString(),
        profileImagePath: json['profileImagePath']?.toString() ?? '',
        totalPoints: int.tryParse(json['totalPoints']?.toString() ?? '0') ?? 0,
        plasticReduced: int.tryParse(json['plasticReduced']?.toString() ?? '0') ?? 0,
        level: int.tryParse(json['level']?.toString() ?? '1') ?? 1,
        joinDate: json['joinDate'] != null 
            ? DateTime.tryParse(json['joinDate'].toString()) ?? DateTime.now()
            : DateTime.now(),
        achievements: json['achievements'] != null 
            ? List<String>.from(json['achievements'])
            : [],
      );
    } catch (e) {
      print('Error parsing user from JSON: $e');
      // Return default user if parsing fails
      return User(
        id: json['id']?.toString() ?? 'unknown',
        name: json['name']?.toString() ?? 'Unknown User',
        email: json['email']?.toString() ?? '',
        profileImagePath: '',
        totalPoints: 0,
        plasticReduced: 0,
        level: 1,
        joinDate: DateTime.now(),
        achievements: [],
      );
    }
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