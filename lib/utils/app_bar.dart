// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalAppbar extends StatelessWidget with PreferredSizeWidget {
  NormalAppbar({Key? key, required this.title, required this.actions})
      : super(key: key);
  String title;
  Widget actions;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w300,
          letterSpacing: .5,
          fontSize: width / 18,
          color: Colors.black,
        ),
      ),
      actions: [actions],
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
