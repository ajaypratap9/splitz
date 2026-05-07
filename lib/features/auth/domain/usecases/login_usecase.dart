import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) throw ArgumentError('Email cannot be empty');
    if (password.isEmpty) throw ArgumentError('Password cannot be empty');
    return _repository.login(email: email, password: password);
  }
}
