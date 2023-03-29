import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

class SignOutUserUsecase {
  final FirebaseRepository repository;

  SignOutUserUsecase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}
