import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/domain/entities/app_entity.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/post/get_single_post_cubit/get_single_post_cubit_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/replay/replay_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/comment/widgets/single_comment_widget.dart';
import 'package:senior_instagram/profile_widget.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:uuid/uuid.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const CommentMainWidget({super.key, required this.appEntity});

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  bool isReply = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);

    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: const Text('Comments'),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back)),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singleUser = singleUserState.user;
            return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
              builder: (context, singlePostState) {
                if (singlePostState is GetSinglePostCubitLoaded) {
                  final singlePost = singlePostState.post;
                  return BlocBuilder<CommentCubit, CommentState>(
                      builder: (context, commentState) {
                    if (commentState is CommentLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: profileWidget(
                                              imageUrl:
                                                  singlePost.userProfileUrl!)),
                                    ),
                                    sizeHorizontal(10),
                                    Text(
                                      "  ${singlePost.username}",
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          sizeVertical(10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${singlePost.description}",
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          sizeVertical(10),
                          const Divider(
                            color: secondaryColor,
                          ),
                          sizeVertical(10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: commentState.comments.length,
                              itemBuilder: ((context, index) {
                                final singleComment =
                                    commentState.comments[index];
                                return BlocProvider(
                                  create: (context) => di.sl<ReplayCubit>(),
                                  child: SingleCommentWidget(
                                    currentUser: singleUser,
                                    comment: singleComment,
                                    onLikePressListner: () {
                                      _likeComment(
                                          comment:
                                              commentState.comments[index]);
                                    },
                                    onLongPressListner: () {
                                      _openModalBottomSheet(
                                          context: context,
                                          comment: singleComment);
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          _commentSection(currentUser: singleUser),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: pinkColor,
                      ),
                    );
                  });
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: pinkColor,
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: pinkColor,
            ),
          );
        },
      ),
    );
  }

  _openModalBottomSheet(
      {required BuildContext context, required CommentEntity comment}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: backgGroundColor.withOpacity(0.8),
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "More Options",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: primaryColor),
                        ),
                      ),
                      sizeVertical(10),
                      const Divider(
                        thickness: 1,
                        color: secondaryColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            _deleteComment(
                                commentId: comment.commentId!,
                                postId: comment.postId!);
                          },
                          child: const Text(
                            "Delete Comment ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: primaryColor),
                          ),
                        ),
                      ),
                      sizeVertical(7),
                      const Divider(
                        thickness: 1,
                        color: secondaryColor,
                      ),
                      sizeVertical(7),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageConsts.updateCommentPage,
                                arguments: comment);
                          },
                          child: const Text(
                            "Update Comment ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      sizeVertical(7),
                      const Divider(
                        thickness: 1,
                        color: secondaryColor,
                      ),
                      sizeVertical(7),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }

  _deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
      comment: CommentEntity(commentId: commentId, postId: postId),
    );
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
      comment:
          CommentEntity(commentId: comment.commentId, postId: comment.postId),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(
                  imageUrl: currentUser.profileUrl!,
                ),
              )),
          sizeHorizontal(10),
          Expanded(
            child: TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: primaryColor),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Add a comment...",
                hintStyle: TextStyle(color: secondaryColor),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _createComment(currentUser);
            },
            child: const Text(
              "Post",
              style: TextStyle(
                  color: pinkColor, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
            comment: CommentEntity(
      totalReplays: 0,
      commentId: const Uuid().v1(),
      createAt: Timestamp.now(),
      likes: [],
      username: currentUser.username,
      userProfileUrl: currentUser.profileUrl,
      description: _descriptionController.text,
      creatorUid: currentUser.uid,
      postId: widget.appEntity.postId,
    ))
        .then((value) {
      _descriptionController.clear();
    });
  }
}
