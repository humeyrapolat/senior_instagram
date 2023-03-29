import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

class SignUpUserUsecase {
  final FirebaseRepository repository;

  SignUpUserUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.signUpUser(user);
  }
}
