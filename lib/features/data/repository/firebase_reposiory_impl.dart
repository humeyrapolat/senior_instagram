import 'dart:io';

import 'package:senior_instagram/features/data/data_sources/remore_data_source/remote_data_source.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';
import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async =>
      await remoteDataSource.createUser(user);

  @override
  Future<String> getCurrentUid() async =>
      await remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      remoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      remoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn() async => await remoteDataSource.isSignIn();

  @override
  Future<void> signInUser(UserEntity user) async =>
      await remoteDataSource.signInUser(user);

  @override
  Future<void> signOut() async => await remoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity user) async =>
      await remoteDataSource.signUpUser(user);

  @override
  Future<void> updateUser(UserEntity user) async =>
      await remoteDataSource.updateUser(user);

  @override
  Future<String> uploadImageToStorage(
          File? imageFile, bool isPost, String childName) async =>
      remoteDataSource.uploadImageToStorage(imageFile, isPost, childName);

  @override
  Future<void> createPost(PostEntity post) async =>
      remoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) async =>
      remoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) async =>
      remoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) =>
      remoteDataSource.readPost(post);

  @override
  Future<void> updatePost(PostEntity post) async =>
      remoteDataSource.updatePost(post);

  @override
  Future<void> createComment(CommentEntity comment) async {
    remoteDataSource.createComment(comment);
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    remoteDataSource.deleteComment(comment);
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    remoteDataSource.likeComment(comment);
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    remoteDataSource.updateComment(comment);
  }

  @override
  Stream<List<CommentEntity>> readComment(String postId) {
    // TODO: implement readComment
    throw UnimplementedError();
  }
}
