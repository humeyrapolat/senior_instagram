import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

//user repository
// they take their data from the repository
class CreateUserUseCase {
  final FirebaseRepository repository;
  CreateUserUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}
