import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../providers/auth_provider.dart';

class AuthViewModel extends AutoDisposeAsyncNotifier<User?> {
  late AuthRepository _authRepository;
  late UserRepository _userRepository;

  @override
  FutureOr<User?> build() {
    _authRepository = ref.read(authProvider);
    _userRepository = ref.read(userProvider);
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = await AsyncValue.guard(() async {
      try {
        final user = await _authRepository.signUp(username, email, password);
        if (user != null) {
          await _userRepository.saveUserData(
            userId: user.uid,
            username: username,
            email: email,
          );
        }
        return user;
      } on FirebaseAuthException catch (e) {
        throw Exception('Sign up failed: ${e.message}');
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = await AsyncValue.guard(() async {
      try {
        final user = await _authRepository.signIn(email, password);
        if (user == null) {
          throw Exception('Sign in failed: No user returned');
        }
        return user;
      } on FirebaseAuthException catch (e) {
        throw Exception('Sign in failed: ${e.message}');
      }
    });
  }

  Future<void> signOut() async {
    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
      return null;
    });
  }
}
