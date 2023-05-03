import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:senior_instagram/features/presentation/widgets/form_container_widget.dart';
import 'package:senior_instagram/profile_widget.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListner;
  final VoidCallback? onLikePressListner;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    this.onLongPressListner,
    this.onLikePressListner,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool isReply = false;

  String _currentUUid = " ";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUUid = value;
      });
    });
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
                                isReply = !isReply;
                              });
                            },
                            child: const Text(
                              "Reply",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          sizeHorizontal(15),
                          const Text(
                            "View Replays",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                            ),
                          ),
                          sizeHorizontal(15),
                        ],
                      ),
                      isReply ? sizeVertical(10) : sizeVertical(0),
                      isReply
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const FormContainerWidget(
                                  hintText: "Add a comment...",
                                ),
                                sizeVertical(10),
                                const Text(
                                  "Post",
                                  style: TextStyle(
                                      color: pinkColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
}
