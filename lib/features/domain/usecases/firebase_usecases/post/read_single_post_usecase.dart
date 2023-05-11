import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

class ReadSinglePostUseCase {
  final FirebaseRepository repository;
  ReadSinglePostUseCase({required this.repository});

  Stream<List<PostEntity>> call(String postId) {
    return repository.readSinglePost(postId);
  }
}
