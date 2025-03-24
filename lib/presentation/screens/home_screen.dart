import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/core/constants.dart';
import '../../application/core/styles.dart';
import '../../domain/models/mission_model.dart';
import '../../domain/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../widgets/edit_task_pop_up.dart';
import '../widgets/alert_banner.dart';
import '../widgets/deletion_confirmation_pop_up.dart';
import '../widgets/get_threat_color.dart';
import '../widgets/styled_snackbar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userViewModelProvider(userId));

    return Scaffold(
      appBar: _buildAppBar(ref),
      body: userAsync.when(
        data: (user) => user != null
            ? _HomeContent(user: user, userId: userId)
            : const Center(
                child: Text('User not found'),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
      floatingActionButton: _buildFAB(context, ref),
    );
  }

  FloatingActionButton _buildFAB(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        final mission = await showDialog(
            context: context, builder: (context) => const EditTaskPopUp());

        if (mission != null) {
          ref.read(userViewModelProvider(userId).notifier).addMission(mission);
        }
      },
      backgroundColor: AppTextStyle.primaryRed,
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }

  AppBar _buildAppBar(WidgetRef ref) {
    return AppBar(
      backgroundColor: AppTextStyle.primaryRed,
      title: Text(
        'Hero Mission Tracker',
        style: AppTextStyle.titleText.copyWith(
          color: Colors.white,
        ),
      ),
      actions: [
        // IconButton(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.lightbulb,
        //     color: Colors.yellow,
        //   ),
        // ),
        IconButton(
          onPressed: () async =>
              await ref.read(authViewModelProvider.notifier).signOut(),
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({
    // super.key,
    required this.user,
    required this.userId,
  });

  final UserModel user;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeMissions = user.missions.where((m) => !m.isCompleted).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (activeMissions >= kActiveTaskToTriggerAlert) const AlertBanner(),
          Text(
            'Welcome, ${user.username}',
            style: AppTextStyle.titleText,
          ),
          const SizedBox(
            height: 10,
          ),
          _buildEnergyBar(user.energy),
          Expanded(
            child: _buildMissionList(context, ref),
          ),
        ],
      ),
    );
  }

  ListView _buildMissionList(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: user.missions.length,
      itemBuilder: (context, index) {
        final mission = user.missions[index];
        return _MissionTile(
          mission: mission,
          userId: userId,
          userEnergy: user.energy,
        );
      },
    );
  }

  Row _buildEnergyBar(int userEnergy) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: userEnergy / 100,
            minHeight: 10,
            color: AppTextStyle.primaryOrange,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '${userEnergy.toString()} %',
          style: AppTextStyle.primaryText.copyWith(
            color: AppTextStyle.primaryOrange,
          ),
        ),
        const Icon(
          Icons.bolt,
          color: AppTextStyle.primaryOrange,
          size: 40,
        )
      ],
    );
  }
}

class _MissionTile extends ConsumerWidget {
  const _MissionTile({
    // super.key,
    required this.mission,
    required this.userEnergy,
    required this.userId,
  });

  final MissionModel mission;
  final int userEnergy;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        mission.name,
        style: AppTextStyle.primaryText
            .copyWith(color: Colors.black.withOpacity(0.8)),
      ),
      subtitle: Text(
        'Threat: ${mission.threatLevel}',
        style: AppTextStyle.secondaryText.copyWith(
          color: getThreatColor(mission.threatLevel),
        ),
      ),
      leading: Checkbox(
        activeColor: AppTextStyle.darkBlue,
        value: mission.isCompleted,
        onChanged: (value) => _handleCheckBoxChange(value, context, ref),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!mission.isCompleted)
            IconButton(
              onPressed: () => _editMission(context, ref),
              icon: const Icon(Icons.edit, color: AppTextStyle.grey),
            ),
          IconButton(
            onPressed: () => _deleteMission(context, ref),
            icon: const Icon(
              Icons.delete,
              color: AppTextStyle.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMission(BuildContext context, WidgetRef ref) async {
    bool deleteTask = true;
    if (!mission.isCompleted) {
      deleteTask = await showDialog(
              context: context,
              builder: (context) => const DeletionConfirmationPopUp()) ??
          false;
    }
    if (deleteTask) {
      ref
          .read(userViewModelProvider(userId).notifier)
          .removeMission(mission.id);
    }
  }

  Future<void> _editMission(BuildContext context, WidgetRef ref) async {
    final updatedMission = await showDialog<MissionModel>(
      context: context,
      builder: (context) => EditTaskPopUp(
        mission: mission,
      ),
    );
    if (updatedMission != null) {
      ref
          .read(userViewModelProvider(userId).notifier)
          .updateMission(updatedMission);
    }
  }

  void _handleCheckBoxChange(bool? value, BuildContext context, WidgetRef ref) {
    if (value == null) return;
    if (userEnergy < mission.getFatigueLevel()) {
      ScaffoldMessenger.of(context).showSnackBar(
        styledSnackbar(
            'You don\'t have enough energy for threat this level now'),
      );
    } else {
      ref
          .read(userViewModelProvider(userId).notifier)
          .updateMission(mission, isCompleted: value);
    }
  }
}
