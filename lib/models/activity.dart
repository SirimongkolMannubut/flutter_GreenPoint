import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int points;
  final int plasticReduction;
  final String category;
  final Color color;
  final String? imageUrl;
  final bool isCompleted;
  final DateTime? completedAt;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.plasticReduction,
    required this.category,
    required this.color,
    this.imageUrl,
    this.isCompleted = false,
    this.completedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      points: json['points'],
      plasticReduction: json['plasticReduction'],
      category: json['category'],
      color: Color(json['colorValue']),
      imageUrl: json['imageUrl'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCode': icon.codePoint,
      'points': points,
      'plasticReduction': plasticReduction,
      'category': category,
      'colorValue': color.value,
      'imageUrl': imageUrl,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    int? points,
    int? plasticReduction,
    String? category,
    Color? color,
    String? imageUrl,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      points: points ?? this.points,
      plasticReduction: plasticReduction ?? this.plasticReduction,
      category: category ?? this.category,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}