import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'RegisterState.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      emit(RegisterFailure("Passwords do not match"));
      return;
    }

    emit(RegisterLoading());

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'createdAt': FieldValue.serverTimestamp(),
        'uid' : userCredential.user?.uid
      });

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(
            "The email address is already in use by another account."));
      } else if (e.code == 'weak-password') {
        emit(RegisterFailure("The password provided is too weak."));
      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure("The email address is invalid."));
      } else {
        emit(RegisterFailure(e.message ?? "An unknown error occurred."));
      }
    } catch (e) {
      emit(RegisterFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
