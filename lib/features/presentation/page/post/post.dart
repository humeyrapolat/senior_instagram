import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/post/post_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/widget/upload_post_main_widget.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class UploadPostPage extends StatelessWidget {
  final UserEntity currentUser;
  const UploadPostPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PostCubit>(),
      child: UploadPostMainWidget(
        currentUser: currentUser,
      ),
    );
  }
}
