import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/domain/entities/comment/comment_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/comment/widgets/edit_comment_main_widget.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;

  const EditCommentPage({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentMainWidget(
        comment: comment,
      ),
    );
  }
}
