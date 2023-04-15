import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_instagram/features/data/data_sources/remore_data_source/remote_data_source.dart';
import 'package:senior_instagram/features/data/data_sources/remore_data_source/remote_data_source_imlp.dart';
import 'package:senior_instagram/features/data/repository/firebase_reposiory_impl.dart';
import 'package:senior_instagram/features/domain/repository/firebase_repository.dart';
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
import 'package:senior_instagram/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';

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

final locator = GetIt.instance;

Future<void> init() async {
  //Cubits
  locator.registerFactory(
    () => AuthCubit(
      isSignInUserUsecase: locator.call(),
      signOutUserUsecase: locator.call(),
      getCurrentUidUseCase: locator.call(),
    ),
  );
  locator.registerFactory(
    () => CredentialCubit(
      signInUserUsecase: locator.call(),
      signUpUserUsecase: locator.call(),
    ),
  );
  locator.registerFactory(
    () => UserCubit(
      getUsersUsecase: locator.call(),
      updateUserUsecase: locator.call(),
    ),
  );
  locator.registerFactory(
    () => GetSingleUserCubit(
      getSingleUserUseCase: locator.call(),
    ),
  );

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

  locator.registerLazySingleton(
      () => IsSignInUserUsecase(repository: locator.call()));
  locator.registerLazySingleton(
      () => SignOutUserUsecase(repository: locator.call()));
  locator.registerLazySingleton(
      () => GetCurrentUidUseCase(repository: locator.call()));
  locator.registerLazySingleton(
      () => SignInUserUsecase(repository: locator.call()));
  locator.registerLazySingleton(
      () => SignUpUserUsecase(repository: locator.call()));
  locator
      .registerLazySingleton(() => GetUsersUsecase(repository: locator.call()));
  locator.registerLazySingleton(
      () => UpdateUserUsecase(repository: locator.call()));
  locator.registerLazySingleton(
      () => CreateUserUseCase(repository: locator.call()));
  locator.registerLazySingleton(
      () => GetSingleUserUseCase(repository: locator.call()));
  // Cloud Storage
  locator.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: locator.call()));

  //Repository

  ///To register the Repository we will again use registerLazySingleton,
  /// and if you notice this FirebaseRepository is an abstract class or a
  ///  contract and cannot be instantiated but instead we will instantiate
  ///  its Implementation of repository. This can become possible by specifying
  ///  the type parameter on the registerLazySingleton method.

  locator.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: locator.call()));

  //RemoteDataSource

  locator.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firestore: locator.call(),
          firebaseAuth: locator.call(),
          firebaseStorage: locator.call()));

  //External

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  locator.registerLazySingleton(() => firebaseFirestore);
  locator.registerLazySingleton(() => auth);
  locator.registerLazySingleton(() => storage);
}
