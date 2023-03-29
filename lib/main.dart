import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_instagram/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:senior_instagram/features/presentation/page/credential/sign_in.dart';
import 'package:senior_instagram/features/presentation/page/main_screen/main_screen.dart';
import 'package:senior_instagram/on_generate_route.dart';
import 'injection_container.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => di.locator<AuthCubit>()..appStarted(context),
        ),
        BlocProvider<UserCubit>(
          create: (context) => di.locator<UserCubit>(),
        ),
        BlocProvider<CredentialCubit>(
          create: (context) => di.locator<CredentialCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.locator<GetSingleUserCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone ',
        darkTheme: ThemeData.dark(),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(
                    uid: authState.uid,
                  );
                } else {
                  return const SignInPage();
                }
              },
            );
          },
        },
      ),
    );
  }
}
