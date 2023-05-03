import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';

class AppEntity {
  final UserEntity? currentUser;
  final PostEntity? postEntity;
  final String? uid;
  final String? postId;

  AppEntity({
    this.currentUser,
    this.postEntity,
    this.uid,
    this.postId,
  });
}
