import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';

import '../../domain/models/mission_model.dart';
import '../../domain/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../core/constants.dart';

class UserViewModel extends FamilyAsyncNotifier<UserModel?, String> {
  late UserRepository _userRepo;

  @override
  Future<UserModel?> build(String userId) async {
    _userRepo = ref.read(userRepositoryProvider);

    UserModel user = await _userRepo.getUserData(userId);
    final updatedUser = _recoverEnergy(user);
    return updatedUser;
  }

  UserModel _recoverEnergy(UserModel user) {
    final lastUpdate = user.lastEnergyUpdate?.toDate() ?? DateTime.now();

    final minutesElapsed = DateTime.now().difference(lastUpdate).inMinutes;

    final recoveryIntervals = minutesElapsed ~/ kRecoveryEnergyInterval;

    final energyToAdd = (recoveryIntervals * kEnergyPerInterval);

    final newEnergy = (user.energy + energyToAdd).clamp(0, 100);

    if (energyToAdd > 0) {
      _userRepo.updateEnergy(userId: arg, newEnergy: newEnergy);
    }
    return user.copyWith(
      energy: newEnergy,
      lastEnergyUpdate: Timestamp.now(),
    );
  }

  Future<void> addMission(MissionModel mission) async {
    final user = state.value;
    if (user == null) return;

    final updatedMissions = [...user.missions, mission];
    state = AsyncValue.data(user.copyWith(missions: updatedMissions));

    await _userRepo.addMission(arg, mission);
  }

  Future<void> removeMission(String missionId) async {
    final user = state.value;
    if (user == null) return;

    final updatedMissions =
        user.missions.where((m) => m.id != missionId).toList();
    state = AsyncValue.data(user.copyWith(missions: updatedMissions));

    final missionToRemove = user.missions.firstWhere((m) => m.id == missionId);
    await _userRepo.removeMission(arg, missionToRemove);
  }

  Future<void> updateMission(
    MissionModel mission, {
    bool? isCompleted,
  }) async {
    final user = state.value;
    if (user == null) return;

    final updatedMissions = user.missions.map((m) {
      if (m.id == mission.id) {
        return m.copyWith(
          name: mission.name,
          threatLevel: mission.threatLevel,
          isCompleted: isCompleted ?? m.isCompleted,
        );
      }
      return m;
    }).toList();

    state = AsyncValue.data(user.copyWith(missions: updatedMissions));

    if (isCompleted != null) {
      await updateEnergy(mission, isCompleted);
    }

    await _userRepo.updateMission(arg, updatedMissions);
  }

  Future<void> updateEnergy(
    MissionModel mission,
    bool isCompleted,
  ) async {
    final user = state.value;
    if (user == null) return;

    int energyDifference = mission.getFatigueLevel();

    int newEnergy = user.energy;

    if (isCompleted) {
      newEnergy -= energyDifference;
    } else {
      newEnergy += energyDifference;
    }

    newEnergy = newEnergy.clamp(0, 100);

    state = AsyncValue.data(user.copyWith(energy: newEnergy));

    await _userRepo.updateEnergy(
      userId: arg,
      newEnergy: newEnergy,
      shouldUpdateTimeStamp: true,
    );
  }
}
