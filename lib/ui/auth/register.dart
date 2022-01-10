import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/net/auth_state.dart';
import 'package:todo/net/authentication_service.dart';
import 'package:todo/ui/auth/auth_dialog.dart';
import 'package:todo/ui/auth/login.dart';
import 'package:todo/ui/auth/register_vm.dart';
import 'package:todo/ui/user/select.dart';
import 'package:todo/utils/app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<RegisterViewModel>(context, listen: false);
    vm.resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppbar(
        title: "REGISTER",
        actions: Container(),
      ),
      body: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) => _screen(context, viewModel),
      ),
    );
  }

  Widget _screen(BuildContext context, RegisterViewModel viewModel) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (viewModel.state?.authStatus == AuthStatus.error) {
      Future.delayed(Duration.zero, () async {
        AuthDialog.show(context, viewModel.state!.error.toString());
      });
    }
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height / 15),
              Text(
                "REGISTER",
                style: GoogleFonts.roboto(
                  fontSize: height / 20,
                ),
              ),
              SizedBox(height: height / 12),
              SizedBox(
                width: width / 1.2,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text("Full Name"),
                    icon: Icon(FontAwesomeIcons.userCircle),
                  ),
                ),
              ),
              SizedBox(height: height / 40),
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
              SizedBox(height: height / 40),
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
              SizedBox(height: height / 40),
              SizedBox(
                width: width / 1.2,
                child: TextFormField(
                  controller: rePasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text("Confirm Password"),
                    icon: Icon(Icons.password),
                  ),
                ),
              ),
              SizedBox(height: height / 30),
              SizedBox(
                height: height / 18,
                width: width / 2.5,
                child: ElevatedButton(
                  onPressed: () async {
                    bool s = await viewModel.register(
                      name: nameController.text,
                      email: emailController.text.trim(),
                      password: passwordController.text.trimRight(),
                      rePassword: rePasswordController.text.trimRight(),
                    );
                    if (s == true) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SelectPage()),
                          (route) => false);
                    }
                  },
                  child: Text(
                    "Register".toUpperCase(),
                    style: GoogleFonts.raleway(fontSize: height / 50),
                  ),
                ),
              ),
              SizedBox(height: height / 30),
              Row(children: <Widget>[
                Expanded(child: Divider(color: Colors.grey.shade700)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("OR",
                      style: GoogleFonts.notoSans(fontSize: height / 50)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade700)),
              ]),
              SizedBox(height: height / 30),
              SizedBox(
                height: height / 16,
                width: width / 1.8,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await context.read<AuthService>().signInWithGoogle();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(FontAwesomeIcons.google),
                  label: const Text("Continue With Google"),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: height / 13.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (_) => false);
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Already Have an Account? "),
                      TextSpan(
                          text: "Log in",
                          style: GoogleFonts.inter(color: Colors.purpleAccent))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
