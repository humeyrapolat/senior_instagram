import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_instagram/features/data/data_sources/remore_data_source/remote_data_source.dart';
import 'package:senior_instagram/features/data/data_sources/remore_data_source/remote_data_source_imlp.dart';
import 'package:senior_instagram/features/data/repository/firebase_reposiory_impl.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/post/create_post_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/post/delete_post_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/post/like_post_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/post/read_post_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/post/update_post_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_users.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/is_signin_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:senior_instagram/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/post/post_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/update_post_page.dart';

/*

getIt, Flutter uygulamalarında dependency injection (bağımlılık enjeksiyonu)
 sağlayan bir pakettir. Dependency injection, bir nesnenin diğer nesneler
  tarafından kullanılan bağımlılıklarını otomatik olarak sağlamak için 
  kullanılan bir tasarım kalıbıdır. Bu, kodun daha kolay test edilebilir
   ve sürdürülebilir hale gelmesine yardımcı olur.

getIt, Dart dilinde yazılmıştır ve Flutter uygulamaları için kullanılabilir.
 Bu paket, widget ağacı üzerindeki farklı parçalar arasında veri paylaşımını
  da sağlar. Bu sayede, uygulamanın farklı parçalarındaki bağımlılıkları
   yönetmek daha kolay hale gelir.

*/

final sl = GetIt.instance;

Future<void> init() async {
  //Cubits
  //User Cubits Injections
  sl.registerFactory(
    () => AuthCubit(
      isSignInUserUsecase: sl.call(),
      signOutUserUsecase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => CredentialCubit(
      signInUserUsecase: sl.call(),
      signUpUserUsecase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => UserCubit(
      getUsersUsecase: sl.call(),
      updateUserUsecase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => GetSingleUserCubit(
      getSingleUserUseCase: sl.call(),
    ),
  );

  //Post Cubits Injections
  sl.registerFactory(() => PostCubit(
      createPostUseCase: sl.call(),
      readPostUseCase: sl.call(),
      updatePostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
      likePostUseCase: sl.call()));

  //Usecases

  ///In our app we will use registerLazySingleton to register our
  /// Cubit’s dependencies which are Use Cases.
  ///  These lazy singletons will create only one instance and
  ///  will use it throughout lifetime of the app.
  /// TR
  ///  Uygulamamızda, Cubit'imizin Kullanım Durumları
  ///  olan bağımlılıklarını kaydetmek için registerLazySingleton
  /// kullanacağız. Bu lazySingleton'lar yalnızca bir örnek oluşturacak
  ///  ve onu uygulamanın ömrü boyunca kullanacaktır.

  // Users Usecase
  sl.registerLazySingleton(() => IsSignInUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignOutUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUseCase(repository: sl.call()));
  // Cloud Storage Usecase
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  //Post Usecase
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));

  //Repository

  ///To register the Repository we will again use registerLazySingleton,
  /// and if you notice this FirebaseRepository is an abstract class or a
  ///  contract and cannot be instantiated but instead we will instantiate
  ///  its Implementation of repository. This can become possible by specifying
  ///  the type parameter on the registerLazySingleton method.

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  //RemoteDataSource

  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  //External

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => storage);
}
