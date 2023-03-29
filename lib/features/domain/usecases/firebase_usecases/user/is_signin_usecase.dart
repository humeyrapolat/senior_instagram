import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

class IsSignInUserUsecase {
  final FirebaseRepository repository;

  IsSignInUserUsecase({required this.repository});

  Future<bool> call() {
    return repository.isSignIn();
  }
}
