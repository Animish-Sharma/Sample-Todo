import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/net/auth_state.dart';
import 'package:todo/net/authentication_service.dart';
import 'package:todo/ui/auth/auth_dialog.dart';
import 'package:todo/ui/auth/login_vm.dart';
import 'package:todo/ui/auth/register.dart';
import 'package:todo/utils/app_bar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<LoginViewModel>(context, listen: false);
    vm.resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NormalAppbar(
          title: "Login".toUpperCase(),
          actions: Container(),
        ),
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return _authScreen(context, viewModel);
          },
        ));
  }

  Widget _authScreen(BuildContext context, LoginViewModel viewModel) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (viewModel.state!.authStatus == AuthStatus.error) {
      Future.delayed(Duration.zero, () async {
        AuthDialog.show(context, viewModel.state!.error.toString());
      });
    }

    final screen = (Center(
      child: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height / 10),
              Text(
                "LOGIN",
                style: GoogleFonts.rubik(
                  fontSize: height / 20,
                ),
              ),
              SizedBox(height: height / 10),
              SizedBox(
                width: width / 1.2,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    icon: Icon(Icons.email_outlined),
                  ),
                ),
              ),
              SizedBox(height: height / 30),
              SizedBox(
                width: width / 1.2,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    icon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              SizedBox(height: height / 30),
              SizedBox(
                height: height / 20,
                width: width / 3,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trimRight());
                  },
                  child: Text("LOGIN",
                      style: GoogleFonts.roboto(fontSize: height / 50)),
                ),
              ),
              SizedBox(height: height / 30),
              Row(children: <Widget>[
                Expanded(child: Divider(color: Colors.grey.shade700)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "OR",
                    style: GoogleFonts.notoSans(fontSize: height / 50),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade700)),
              ]),
              SizedBox(height: height / 30),
              SizedBox(
                height: height / 18,
                width: width / 2,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AuthService>().signInWithGoogle();
                  },
                  icon: const Icon(FontAwesomeIcons.google),
                  label: const Text("Log In With Google"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: height / 4.9),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterPage()));
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Dont have an account? No Problem "),
                      TextSpan(
                          text: "Register",
                          style: GoogleFonts.inter(color: Colors.purpleAccent))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
    return screen;
  }
}
