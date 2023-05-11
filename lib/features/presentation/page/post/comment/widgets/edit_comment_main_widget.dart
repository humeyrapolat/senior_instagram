import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:senior_instagram/features/presentation/page/profile/widgets/profile_form_widget.dart';
import 'package:senior_instagram/features/presentation/widgets/button_container_widget.dart';
import 'package:senior_instagram/util/consts.dart';

class EditCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;

  const EditCommentMainWidget({super.key, required this.comment});

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {
  TextEditingController? _descriptionController;
  bool? _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.comment.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: const Text("Edit Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            ProfileFormWidget(
              title: "comment",
              controller: _descriptionController,
            ),
            sizeVertical(10),
            ButtonContainerWidget(
              color: pinkColor,
              text: "Save Changes",
              onTapListener: () {
                _editComment();
              },
            ),
            sizeVertical(10),
            _isUpdating == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Updatimg",
                        style: TextStyle(color: pinkColor),
                      ),
                      sizeHorizontal(10),
                      const CircularProgressIndicator()
                    ],
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
      comment: CommentEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _descriptionController!.text,
      ),
    )
        .then((value) {
      _isUpdating = false;
      _descriptionController!.clear();
    });
    Navigator.pop(context);
  }
}
