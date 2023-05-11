part of 'get_single_post_cubit_cubit.dart';

abstract class GetSinglePostState extends Equatable {
  const GetSinglePostState();
}

class GetSinglePostCubitInitial extends GetSinglePostState {
  @override
  List<Object> get props => [];
}

class GetSinglePostCubitLoading extends GetSinglePostState {
  @override
  List<Object> get props => [];
}

class GetSinglePostCubitLoaded extends GetSinglePostState {
  final PostEntity post;
  GetSinglePostCubitLoaded({required this.post});

  @override
  List<Object> get props => [post];
}

class GetSinglePostCubitFailure extends GetSinglePostState {
  @override
  List<Object> get props => [];
}
