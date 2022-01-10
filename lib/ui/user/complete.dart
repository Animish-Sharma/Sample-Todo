import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/user/detail.dart';
import 'package:todo/utils/app_bar.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({Key? key}) : super(key: key);

  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("Todo");
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: NormalAppbar(
        title: "Completed Todo(s)",
        actions: Container(),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: StreamBuilder(
          stream: _ref
              .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where("completed", isEqualTo: true)
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, idx) {
                  DocumentSnapshot ds = snapshot.data!.docs[idx];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => TodoDetail(
                                        id: ds.id,
                                        completed: true,
                                      )));
                        },
                        style: ListTileStyle.list,
                        title: Text("${idx + 1}. ${ds['title']}"),
                      ),
                      const Divider(color: Colors.grey)
                    ],
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
