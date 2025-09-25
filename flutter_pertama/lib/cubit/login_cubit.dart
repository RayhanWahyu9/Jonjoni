import 'package:flutter_bloc/flutter_bloc.dart';
class LoginCubit extends Cubit<bool> {
  LoginCubit() : super(false);
  Future<bool> login(String username, String password) async {
    emit(true);
    await Future.delayed(const Duration(seconds: 2));
    emit(false); 
    if (username.isEmpty || password.isEmpty) {
      return false; 
    }
    return true; 
  }
}