class PartnerStore {
  final String id;
  final String name;
  final String category;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String imageUrl;
  final double rating;
  final List<String> tags;
  final String discount;
  final int pointsRequired;
  final String openHours;
  final String emoji;

  PartnerStore({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.imageUrl,
    required this.rating,
    required this.tags,
    required this.discount,
    required this.pointsRequired,
    required this.openHours,
    required this.emoji,
  });

  factory PartnerStore.fromJson(Map<String, dynamic> json) {
    return PartnerStore(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      tags: List<String>.from(json['tags']),
      discount: json['discount'],
      pointsRequired: json['pointsRequired'],
      openHours: json['openHours'],
      emoji: json['emoji'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'imageUrl': imageUrl,
      'rating': rating,
      'tags': tags,
      'discount': discount,
      'pointsRequired': pointsRequired,
      'openHours': openHours,
      'emoji': emoji,
    };
  }
}