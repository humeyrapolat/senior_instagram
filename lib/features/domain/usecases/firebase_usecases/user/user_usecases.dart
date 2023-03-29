
/*
//user repository
// they take their data from the repository
class UserUseCase {
  final FirebaseRepository repository;
  UserUseCase({required this.repository});

  //credential
  Future<void> signInUser(UserEntity user) {
    return repository.signInUser(user);
  }

  Future<void> signUpUser(UserEntity user) {
    return repository.signUpUser(user);
  }

  Future<bool> isSignIn() {
    return repository.isSignIn();
  }

  Future<void> signOut() {
    return repository.signOut();
  }

  //user
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    return repository.getUsers(user);
  }

  Stream<List<UserEntity>> getSingleUser(String uid) {
    return repository.getSingleUser(uid);
  }

  Future<void> createUser(UserEntity user) {
    return repository.createUser(user);
  }

  Future<void> updateUser(UserEntity user) {
    return repository.updateUser(user);
  }

  Future<String> getCurrentUid() {
    return repository.getCurrentUid();
  }
}
*/