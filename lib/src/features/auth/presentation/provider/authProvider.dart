import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>(
      (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);
void logout(WidgetRef ref) async {
  await ref.read(firebaseAuthProvider).signOut();
}