import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';
import 'package:senior_instagram/features/domain/entities/replay/replay_entity.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:senior_instagram/features/presentation/cubit/replay/replay_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/comment/widgets/single_replay_Widget.dart';
import 'package:senior_instagram/features/presentation/widgets/form_container_widget.dart';
import 'package:senior_instagram/profile_widget.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:senior_instagram/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListner;
  final VoidCallback? onLikePressListner;
  final UserEntity currentUser;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    this.onLongPressListner,
    this.onLikePressListner,
    required this.currentUser,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isReply = false;
  final TextEditingController _replayDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _replayDescriptionController.dispose();
    super.dispose();
  }

  String _currentUUid = " ";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUUid = value;
      });
    });

    BlocProvider.of<ReplayCubit>(context).getReplays(
      replay: ReplayEntity(
        postId: widget.comment.postId!,
        commentId: widget.comment.commentId!,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListner,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(
                  imageUrl: widget.comment.userProfileUrl!,
                ),
              ),
            ),
            sizeHorizontal(10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.comment.username!,
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: widget.onLikePressListner!,
                              child: Icon(
                                widget.comment.likes!.contains(_currentUUid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color:
                                    widget.comment.likes!.contains(_currentUUid)
                                        ? Colors.red
                                        : secondaryColor,
                                size: 20,
                              )),
                        ],
                      ),
                      sizeVertical(4),
                      Text(
                        widget.comment.description!,
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      sizeVertical(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(widget.comment.createAt!.toDate()),
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                            ),
                          ),
                          sizeHorizontal(15),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isReply = !_isReply;
                              });
                            },
                            child: const Text(
                              "Replay",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          sizeHorizontal(15),
                          GestureDetector(
                            onTap: () {
                              widget.comment.totalReplays == 0
                                  ? toast("No Replays")
                                  : BlocProvider.of<ReplayCubit>(context)
                                      .getReplays(
                                      replay: ReplayEntity(
                                        postId: widget.comment.postId!,
                                        commentId: widget.comment.commentId!,
                                      ),
                                    );
                            },
                            child: const Text(
                              "View Replays",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          sizeHorizontal(15),
                        ],
                      ),
                      BlocBuilder<ReplayCubit, ReplayState>(
                        builder: (context, replayState) {
                          if (replayState is ReplayLoaded) {
                            final replays = replayState.replays
                                .where((element) =>
                                    element.commentId ==
                                    widget.comment.commentId)
                                .toList();
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: replays.length,
                              itemBuilder: (context, index) {
                                return SingleReplayWidget(
                                  replay: replays[index],
                                  onLongPressListener: () {
                                    _openModalBottomSheet(
                                        replay: replays[index],
                                        context: context);
                                  },
                                  onLikePressListener: () {
                                    _likeReplay(
                                      replay: replays[index],
                                    );
                                  },
                                );
                              },
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      _isReply ? sizeVertical(10) : sizeVertical(0),
                      _isReply
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FormContainerWidget(
                                  hintText: "Add a comment...",
                                  controller: _replayDescriptionController,
                                ),
                                sizeVertical(10),
                                GestureDetector(
                                  onTap: () {
                                    _createReplay();
                                  },
                                  child: const Text(
                                    "Post",
                                    style: TextStyle(
                                        color: pinkColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openModalBottomSheet(
      {required BuildContext context, required ReplayEntity replay}) {
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
                            _deleteComment(replay: replay);
                          },
                          child: const Text(
                            "Delete Replay ",
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
                            //     Navigator.pushNamed(
                            //        context, PageConsts.updateCommentPage,
                            //        arguments: comment);
                          },
                          child: const Text(
                            "Update Replay ",
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

  _createReplay() {
    BlocProvider.of<ReplayCubit>(context)
        .createReplay(
            replay: ReplayEntity(
      replayId: const Uuid().v1(),
      createAt: Timestamp.now(),
      likes: [],
      username: widget.currentUser.username!,
      userProfileUrl: widget.currentUser.profileUrl!,
      creatorUid: widget.currentUser.uid!,
      postId: widget.comment.postId!,
      commentId: widget.comment.commentId!,
      description: _replayDescriptionController.text,
    ))
        .then((value) {
      setState(() {
        _isReply = false;
        _replayDescriptionController.clear();
      });
    });
  }

  _deleteComment({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).deleteReplay(
        replay: ReplayEntity(
      postId: replay.postId!,
      commentId: replay.commentId!,
      replayId: replay.replayId,
    ));
  }

  _likeReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(
        replay: ReplayEntity(
      postId: replay.postId!,
      commentId: replay.commentId!,
      replayId: replay.replayId,
    ));
  }
}
