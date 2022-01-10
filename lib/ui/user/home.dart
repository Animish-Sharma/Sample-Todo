import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/ui/user/detail.dart';
import 'package:todo/ui/user/home_vm.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return _screen(context, viewModel);
      },
    );
  }

  Widget _screen(BuildContext context, HomeViewModel viewModel) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var streamBuilder = StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Todo")
          .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("completed", isEqualTo: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, idx) {
              DocumentSnapshot ds = snapshot.data!.docs[idx];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => TodoDetail(id: ds.id)),
                      (route) => true);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: height / 50, horizontal: width / 10),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text("${ds["title"]}")),
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                bool s = await viewModel.delete(ds.id);
                                if (s) setState(() {});
                              },
                              child: Icon(
                                FontAwesomeIcons.trash,
                                color: Colors.red.shade500,
                                size: height / 35,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool s = await viewModel.complete(ds.id);
                                if (s) setState(() {});
                              },
                              child: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.green.shade600,
                                size: height / 35,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 100))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.data?.docs.isEmpty == true) {
          return Column(
            children: <Widget>[
              SizedBox(height: height / 5),
              Icon(
                FontAwesomeIcons.times,
                color: Colors.red.shade500,
                size: height / 6,
              ),
              SizedBox(height: height / 20),
              Center(
                child: Text(
                  "No Todos Found",
                  style: GoogleFonts.inter(fontSize: height / 23),
                ),
              ),
            ],
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 2.2, vertical: height / 2.7),
          child: const CircularProgressIndicator(),
        );
      },
    );
    return streamBuilder;
  }
}
