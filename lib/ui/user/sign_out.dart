import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/data/models/user.dart';
import 'package:todo/data/repo/user_repo.dart';
import 'package:provider/provider.dart';
import 'package:todo/net/authentication_service.dart';
import 'package:todo/ui/user/select.dart';

class SignOutPage extends StatelessWidget {
  SignOutPage({Key? key}) : super(key: key);
  final UserRepo _userRepo = UserRepo();

  Future<User?> getUser() async {
    return await _userRepo.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 2.2, vertical: height / 2.7),
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          User data = snapshot.data;
          return SizedBox(
            width: width,
            height: height,
            child: Column(
              children: <Widget>[
                SizedBox(height: height / 7),
                Center(
                  child: Text(
                    "Hi, \n${data.name}",
                    style: GoogleFonts.ptSans(fontSize: height / 20),
                  ),
                ),
                SizedBox(height: height / 15),
                Center(
                  child: Text(
                    "Are you sure, \n You want to sign out?",
                    style: GoogleFonts.rubik(
                      fontSize: height / 30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: height / 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: height / 16,
                      width: width / 2.5,
                      child: TextButton.icon(
                        icon: const Icon(FontAwesomeIcons.times),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[350],
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const SelectPage()));
                        },
                        label: Text(
                          "NO",
                          style: GoogleFonts.ptSans(fontSize: width / 18),
                        ),
                      ),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      height: height / 16,
                      width: width / 2.5,
                      child: TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          await context.read<AuthService>().signOut();
                        },
                        child: Text(
                          "YES",
                          style: GoogleFonts.ptSans(
                              color: Colors.white, fontSize: width / 18),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
