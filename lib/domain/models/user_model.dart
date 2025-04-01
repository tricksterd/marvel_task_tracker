import 'package:cloud_firestore/cloud_firestore.dart';

import 'mission_model.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final int energy;
  final List<MissionModel> missions;
  final Timestamp? lastEnergyUpdate;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.energy,
    required this.missions,
    this.lastEnergyUpdate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'energy': energy,
      'missions': missions.map((x) => x.toJson()).toList(),
      'lastEnergyUpdate': lastEnergyUpdate ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      energy: json['energy']?.toInt() ?? 0,
      missions: List<MissionModel>.from(
          json['missions']?.map((x) => MissionModel.fromJson(x)) ?? []),
      lastEnergyUpdate: json['lastEnergyUpdate'] as Timestamp?,
    );
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    int? energy,
    List<MissionModel>? missions,
    Timestamp? lastEnergyUpdate,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      energy: energy ?? this.energy,
      missions: missions ?? this.missions,
      lastEnergyUpdate: lastEnergyUpdate ?? this.lastEnergyUpdate,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, energy: $energy, missions: $missions, lastEnergyUpdate: $lastEnergyUpdate)';
  }
}
