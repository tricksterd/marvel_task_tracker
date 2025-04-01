import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/viewmodels/user_view_model.dart';
import '../data/repositories/user_repository.dart';
import '../domain/models/user_model.dart';

final userRepositoryProvider =
    Provider((ref) => UserRepository(FirebaseFirestore.instance));

final userViewModelProvider =
    AsyncNotifierProvider.family<UserViewModel, UserModel?, String>(
  () => UserViewModel(),
);
