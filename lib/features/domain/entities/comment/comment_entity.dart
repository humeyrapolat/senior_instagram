import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? description;
  final String? commentId;
  final String? creatorUid;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplays;
  final String? postId;

  CommentEntity({
    this.description,
    this.commentId,
    this.creatorUid,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplays,
    this.postId,
  });

  @override
  List<Object?> get props => [
        description,
        commentId,
        creatorUid,
        username,
        userProfileUrl,
        createAt,
        likes,
        totalReplays,
        postId
      ];
}
