import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Demo authentication logic
      if (_isValidCredentials(email, password)) {
        emit(LoginSuccess());
      } else {
        emit(LoginError('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginError('An error occurred during login'));
    }
  }

  bool _isValidCredentials(String email, String password) {
    // Demo credentials
    const validCredentials = {
      'admin@demo.com': 'demo123',
      'employee@demo.com': 'demo123',
      'superadmin@demo.com': 'demo123',
    };
    
    return validCredentials[email] == password;
  }

  void logout() {
    emit(LoginInitial());
  }
}

