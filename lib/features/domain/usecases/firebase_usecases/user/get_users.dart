import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

class GetUsersUsecase {
  final FirebaseRepository repository;

  GetUsersUsecase({required this.repository});

  //user
  Stream<List<UserEntity>> call(UserEntity user) {
    return repository.getUsers(user);
  }
}
