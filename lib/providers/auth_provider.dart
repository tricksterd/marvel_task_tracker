import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/viewmodels/auth_view_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';

final authProvider = Provider((ref) => AuthRepository(FirebaseAuth.instance));

final userProvider =
    Provider((ref) => UserRepository(FirebaseFirestore.instance));

final authViewModelProvider =
    AutoDisposeAsyncNotifierProvider<AuthViewModel, User?>(
  () => AuthViewModel(),
);
