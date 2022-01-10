import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/repo/todo_repo.dart';
import 'package:todo/net/flutterfire.dart';
import 'package:todo/net/request_state.dart';
import 'package:todo/net/todo_creation.dart';
import 'package:todo/ui/user/edit.dart';
import 'package:todo/ui/user/home.dart';
import 'package:todo/ui/user/select.dart';
import 'package:todo/utils/app_bar.dart';
import 'package:todo/utils/request_dialog.dart';

class TodoDetail extends StatefulWidget {
  final String id;
  final bool completed;

  const TodoDetail({Key? key, required this.id, this.completed = false})
      : super(key: key);

  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  final TodoRepo _todoRepo = TodoRepo();
  Future<Todo> getTodo({required String id}) async {
    Todo todo = await _todoRepo.getTodo(id);
    return todo;
  }

  @override
  Widget build(BuildContext context) {
    TodoService _todoService =
        TodoService(TodoCreationService(_todoRepo, FirebaseAuth.instance));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: NormalAppbar(
        title: "Detail",
        actions: Container(),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getTodo(id: widget.id),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 2.2, vertical: height / 2.7),
                  child: const CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                Todo data = snapshot.data;
                return SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          capitalizeLetter(data.title),
                          style: GoogleFonts.notoSans(fontSize: height / 20),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      SizedBox(
                        width: width / 1.2,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      data.description.toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: width / 18,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              RequestState s =
                                  await _todoService.deleteTodo(id: widget.id);
                              if (s.requestStatus == RequestStatus.success) {
                                Navigator.of(context).pop();
                              } else if (s.requestStatus ==
                                  RequestStatus.error) {
                                return RequestDialog.show(
                                    context, s.error.toString());
                              }
                            },
                            icon: const Icon(FontAwesomeIcons.trashAlt),
                            label: const Text("Delete"),
                          ),
                          !widget.completed
                              ? OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditPage(
                                        id: widget.id,
                                        defaultTitle: data.title,
                                        defaultDescription: data.description,
                                      ),
                                    ));
                                  },
                                  icon: const Icon(FontAwesomeIcons.pencilAlt),
                                  label: const Text("Edit it"),
                                )
                              : Container(),
                          !widget.completed
                              ? OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.green[400],
                                    primary: Colors.white,
                                  ),
                                  onPressed: () async {
                                    RequestState s = await _todoService
                                        .completed(id: widget.id);
                                    if (s.requestStatus ==
                                        RequestStatus.success) {
                                      Navigator.of(context).pop();
                                    } else if (s.requestStatus ==
                                        RequestStatus.error) {
                                      return RequestDialog.show(
                                          context, s.error.toString());
                                    }
                                  },
                                  icon: const Icon(FontAwesomeIcons.check),
                                  label: const Text("Completed"),
                                )
                              : OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.yellow[800],
                                    primary: Colors.white,
                                  ),
                                  onPressed: () async {
                                    RequestState s = await _todoService.revert(
                                        id: widget.id);
                                    if (s.requestStatus ==
                                        RequestStatus.success) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectPage()));
                                    } else if (s.requestStatus ==
                                        RequestStatus.error) {
                                      return RequestDialog.show(
                                          context, s.error.toString());
                                    }
                                  },
                                  icon: const Icon(FontAwesomeIcons.backward),
                                  label: const Text("Revert"),
                                ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  String capitalizeLetter(String str) {
    String string = str[0].toUpperCase() + str.substring(1);
    return string;
  }
}
