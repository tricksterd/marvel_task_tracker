import 'package:uuid/uuid.dart';

const uuid = Uuid();

class MissionModel {
  final String id;
  final String name;
  final String threatLevel;
  final bool isCompleted;

  MissionModel({
    String? id,
    required this.name,
    required this.threatLevel,
    this.isCompleted = false,
  }) : id = id ?? uuid.v4();

  int getFatigueLevel() {
    switch (threatLevel) {
      case 'Low':
        return 10;
      case 'Medium':
        return 20;
      case 'High':
        return 30;
      case 'World-Ending':
        return 40;
      default:
        return 10;
    }
  }

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      threatLevel: json['threatLevel'] ?? 'Low',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'threatLevel': threatLevel,
      'isCompleted': isCompleted,
    };
  }

  MissionModel copyWith({
    String? name,
    String? threatLevel,
    bool? isCompleted,
  }) {
    return MissionModel(
      name: name ?? this.name,
      threatLevel: threatLevel ?? this.threatLevel,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
