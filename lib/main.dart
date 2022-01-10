// ignore_for_file: constant_identifier_names, unused_local_variable, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/repo/todo_repo.dart';
import 'package:todo/data/repo/user_repo.dart';
import 'package:todo/net/authentication_service.dart';
import 'package:todo/net/flutterfire.dart';
import 'package:todo/net/todo_creation.dart';
import 'package:todo/net/user_creation.dart';
import 'package:todo/ui/auth/login.dart';
import 'package:todo/ui/auth/login_vm.dart';
import 'package:todo/ui/auth/register.dart';
import 'package:todo/ui/auth/register_vm.dart';
import 'package:todo/ui/user/add_vm.dart';
import 'package:todo/ui/user/home_vm.dart';
import 'package:todo/ui/user/select.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

const HomeRoute = "/";
const LoginRoute = "/login";
const RegisterRoute = "/register";

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthService authService =
      AuthService(FirebaseAuth.instance, UserCreationService(UserRepo()));
  final TodoService todoService =
      TodoService(TodoCreationService(TodoRepo(), FirebaseAuth.instance));
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => authService,
        ),
        ChangeNotifierProvider<LoginViewModel>(
            create: (_) => LoginViewModel(authService: authService)),
        ChangeNotifierProvider<RegisterViewModel>(
            create: (_) => RegisterViewModel(authService: authService)),
        ChangeNotifierProvider<AddViewModel>(
            create: (_) => AddViewModel(todoService: todoService)),
        ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(todoService: todoService)),
        StreamProvider(
          create: (context) => authService.authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        onGenerateRoute: _routes(),
      ),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      Widget screen;
      switch (settings.name) {
        case HomeRoute:
          screen = const SelectPage();
          break;
        case LoginRoute:
          screen = const LoginPage();
          break;
        case RegisterRoute:
          screen = const RegisterPage();
          break;
        default:
          return null;
      }
    };
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super();
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();
    if (firebaseuser != null) return const SelectPage();
    return const LoginPage();
  }
}
