import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/mission_model.dart';

import '../../domain/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> saveUserData({
    required userId,
    required username,
    required email,
    List<MissionModel> missions = const [],
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set(
        {
          'username': username,
          'email': email,
          'energy': 100,
          'missions': missions.map((mission) => mission.toJson()).toList(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<UserModel> getUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!);
      }
      throw Exception('User not found');
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> addMission(String userId, MissionModel mission) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'missions': FieldValue.arrayUnion([mission.toJson()]),
      });
    } catch (e) {
      throw Exception('Failed to add mission: $e');
    }
  }

  Future<void> removeMission(String userId, MissionModel mission) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'missions': FieldValue.arrayRemove([mission.toJson()]),
      });
    } catch (e) {
      throw Exception('Failed to remove mission: $e');
    }
  }

  Future<void> updateMission(
      String userId, List<MissionModel> updatedMissions) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'missions': updatedMissions.map((m) => m.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('Failed to update mission: $e');
    }
  }

  Future<void> updateEnergy({
    required String userId,
    required int newEnergy,
    bool shouldUpdateTimeStamp = false,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      Map<String, dynamic> fieldToUpdate = {
        'energy': newEnergy,
      };

      if (shouldUpdateTimeStamp) {
        fieldToUpdate['lastEnergyUpdate'] = FieldValue.serverTimestamp();
      }
      await userRef.update(fieldToUpdate);
    } catch (e) {
      throw Exception('Failed to update energy: $e');
    }
  }
}
