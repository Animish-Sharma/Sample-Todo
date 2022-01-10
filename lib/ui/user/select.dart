import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo/ui/user/add.dart';
import 'package:todo/ui/user/complete.dart';
import 'package:todo/ui/user/home.dart';
import 'package:todo/ui/user/sign_out.dart';
import 'package:todo/utils/app_bar.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  static final List<Widget> pages = [
    const HomePage(),
    const AddPage(),
    SignOutPage(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: NormalAppbar(
        title: selectedIndex == 0
            ? "Home"
            : selectedIndex == 1
                ? "Add Todo"
                : "Sign Out?",
        actions: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 25),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CompletePage()));
            },
            child: const Icon(FontAwesomeIcons.check),
          ),
        ),
      ),
      body: SingleChildScrollView(child: pages[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          selectedIndex = value;
        }),
        currentIndex: selectedIndex,
        selectedIconTheme: const IconThemeData(size: 30),
        selectedFontSize: 14,
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Add Todo",
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            label: "SignOut",
            icon: Icon(Icons.person),
          )
        ],
      ),
    );
  }
}
