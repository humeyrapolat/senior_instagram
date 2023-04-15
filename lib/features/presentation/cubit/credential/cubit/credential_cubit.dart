import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  ///In our app we will use registerLazySingleton to register our Cubit’s
  ///dependencies which are Use Cases. These lazy singletons will create
  ///only one instance and will use it throughout lifetime of the app. These
  ///registrations will go down below the Use Cases comment.

  final SignInUserUsecase signInUserUsecase;
  final SignUpUserUsecase signUpUserUsecase;

  CredentialCubit(
      {required this.signInUserUsecase, required this.signUpUserUsecase})
      : super(CredentialInitial());

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(CredentialLoading());
    try {
      await signInUserUsecase
          .call(UserEntity(email: email, password: password));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUserUsecase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
