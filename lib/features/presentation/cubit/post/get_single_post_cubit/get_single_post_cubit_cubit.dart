import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/post/read_single_post_usecase.dart';

part 'get_single_post_cubit_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
  final ReadSinglePostUseCase readSinglePostUseCase;

  GetSinglePostCubit({required this.readSinglePostUseCase})
      : super(GetSinglePostCubitInitial());

  Future<void> getSinglePost({required String postId}) async {
    emit(GetSinglePostCubitLoading());
    try {
      final streamResponse = readSinglePostUseCase.call(postId);
      streamResponse.listen((post) {
        emit(GetSinglePostCubitLoaded(post: post.first));
      });
    } on SocketException catch (_) {
      emit(GetSinglePostCubitFailure());
    } catch (_) {
      emit(GetSinglePostCubitFailure());
    }
  }
}
