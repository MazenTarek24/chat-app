import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginState.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found for that email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.Please check and try again.";
          break;
        default:
          errorMessage = "this user not exist.Please try again!";
      }
      emit(LoginFailure(errorMessage));
    } catch (e) {
      emit(LoginFailure("An unknown error occurred: ${e.toString()}"));
    }
  }
}
