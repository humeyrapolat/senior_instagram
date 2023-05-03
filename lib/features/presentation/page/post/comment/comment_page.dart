import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/domain/entities/app_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/comment/widgets/comment_main_widget.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;
  const CommentPage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.sl<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
      ],
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
