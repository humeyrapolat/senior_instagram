import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  final String? description;
  final String? commentId;
  final String? creatorUid;
  final String? username;
  final String? userProfileUrl;
  final Timestamp? createAt;
  final List<String>? likes;
  final num? totalReplays;
  final String? postId;

  CommentModel({
    this.description,
    this.commentId,
    this.creatorUid,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplays,
    this.postId,
  }) : super(
          commentId: commentId,
          totalReplays: totalReplays,
          postId: postId,
          creatorUid: creatorUid,
          username: username,
          description: description,
          likes: likes,
          createAt: createAt,
          userProfileUrl: userProfileUrl,
        );

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      postId: snapshot['postId'],
      creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      likes: List.from(snap.get('likes')),
      createAt: snapshot['createAt'],
      userProfileUrl: snapshot['userProfileUrl'],
      totalReplays: snapshot['totalReplays'],
      commentId: snapshot['commentId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "creatorUid": creatorUid,
        "username": username,
        "description": description,
        "likes": likes,
        "totalReplays": totalReplays,
        "commentId": commentId,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
      };
}
