import 'package:flutter/material.dart';

enum WasteType {
  plastic,
  paper,
  glass,
  metal,
  organic,
  electronic,
  hazardous,
  textile
}

class WasteItem {
  final String id;
  final String name;
  final WasteType type;
  final double weight; // in grams
  final double co2Impact; // CO2 saved by proper disposal (kg)
  final int points;
  final IconData icon;
  final Color color;
  final String description;
  final String disposalTip;

  WasteItem({
    required this.id,
    required this.name,
    required this.type,
    required this.weight,
    required this.co2Impact,
    required this.points,
    required this.icon,
    required this.color,
    required this.description,
    required this.disposalTip,
  });

  factory WasteItem.fromJson(Map<String, dynamic> json) {
    return WasteItem(
      id: json['id'],
      name: json['name'],
      type: WasteType.values[json['typeIndex']],
      weight: json['weight'].toDouble(),
      co2Impact: json['co2Impact'].toDouble(),
      points: json['points'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue']),
      description: json['description'],
      disposalTip: json['disposalTip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'typeIndex': type.index,
      'weight': weight,
      'co2Impact': co2Impact,
      'points': points,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
      'description': description,
      'disposalTip': disposalTip,
    };
  }
}

class WasteEntry {
  final String id;
  final DateTime date;
  final List<WasteItem> items;
  final String? note;
  final double totalWeight;
  final double totalCo2Saved;
  final int totalPoints;

  WasteEntry({
    required this.id,
    required this.date,
    required this.items,
    this.note,
    required this.totalWeight,
    required this.totalCo2Saved,
    required this.totalPoints,
  });

  factory WasteEntry.fromJson(Map<String, dynamic> json) {
    return WasteEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List).map((item) => WasteItem.fromJson(item)).toList(),
      note: json['note'],
      totalWeight: json['totalWeight'].toDouble(),
      totalCo2Saved: json['totalCo2Saved'].toDouble(),
      totalPoints: json['totalPoints'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'note': note,
      'totalWeight': totalWeight,
      'totalCo2Saved': totalCo2Saved,
      'totalPoints': totalPoints,
    };
  }

  static WasteEntry create(List<WasteItem> items, {String? note}) {
    final totalWeight = items.fold(0.0, (sum, item) => sum + item.weight);
    final totalCo2Saved = items.fold(0.0, (sum, item) => sum + item.co2Impact);
    final totalPoints = items.fold(0, (sum, item) => sum + item.points);

    return WasteEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: items,
      note: note,
      totalWeight: totalWeight,
      totalCo2Saved: totalCo2Saved,
      totalPoints: totalPoints,
    );
  }
}