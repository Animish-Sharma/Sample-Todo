// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/data/repo/todo_repo.dart';
import 'package:todo/net/flutterfire.dart';
import 'package:todo/net/request_state.dart';
import 'package:todo/net/todo_creation.dart';
import 'package:todo/ui/user/select.dart';
import 'package:todo/utils/app_bar.dart';
import 'package:todo/utils/request_dialog.dart';

class EditPage extends StatefulWidget {
  final String id;
  String defaultTitle;
  String defaultDescription;
  EditPage(
      {Key? key,
      required this.id,
      required this.defaultTitle,
      required this.defaultDescription})
      : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TodoRepo _todoRepo = TodoRepo();

  @override
  Widget build(BuildContext context) {
    TodoService _todoService =
        TodoService(TodoCreationService(_todoRepo, FirebaseAuth.instance));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _titleController.text = widget.defaultTitle;
    _descriptionController.text = widget.defaultDescription;
    cursor(_titleController);
    cursor(_descriptionController);
    return Scaffold(
      appBar: NormalAppbar(
        title: widget.defaultTitle,
        actions: Container(),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: height / 20),
                child: SvgPicture.asset(
                  "assets/os.svg",
                  width: width / 1.5,
                ),
              ),
              Center(
                  child: Text(
                "Edit: ${capitalizeLetter(widget.defaultTitle)}",
                style: GoogleFonts.poppins(
                  fontSize: widget.defaultTitle.length <= 15
                      ? width / 10
                      : widget.defaultTitle.length <= 30
                          ? width / 15
                          : width / 20,
                ),
              )),
              SizedBox(height: height / 30),
              SizedBox(
                width: width / 1.15,
                child: TextFormField(
                  controller: _titleController,
                  onChanged: (s) => widget.defaultTitle = s,
                  style: GoogleFonts.raleway(fontSize: width / 20),
                  decoration: InputDecoration(
                      label: Text(
                        "Title",
                        style: GoogleFonts.raleway(fontSize: height / 40),
                      ),
                      prefixIcon: const Icon(FontAwesomeIcons.heading)),
                ),
              ),
              SizedBox(height: height / 30),
              SizedBox(
                width: width / 1.15,
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 10 * 10,
                  minLines: 1,
                  onChanged: (s) => widget.defaultDescription = s,
                  style: GoogleFonts.raleway(fontSize: width / 20),
                  decoration: InputDecoration(
                    label: Text(
                      "Description",
                      style: GoogleFonts.raleway(fontSize: height / 40),
                    ),
                    prefixIcon: const Icon(FontAwesomeIcons.stickyNote),
                    prefixIconColor: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: height / 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width / 3,
                    height: height / 20,
                    child: ElevatedButton.icon(
                      icon: const Icon(FontAwesomeIcons.times),
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: const Text("Cancel"),
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    height: height / 20,
                    child: ElevatedButton.icon(
                      icon: const Icon(FontAwesomeIcons.check),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () async {
                        RequestState s = await _todoService.edit(
                          id: widget.id,
                          title: _titleController.text,
                          description: _descriptionController.text,
                        );
                        if (s.requestStatus == RequestStatus.success) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const SelectPage(),
                              ),
                              (route) => false);
                          return;
                        } else if (s.requestStatus == RequestStatus.error) {
                          return RequestDialog.show(
                            context,
                            s.error.toString(),
                          );
                        }
                        setState(() {});
                      },
                      label: const Text("Submit"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String capitalizeLetter(String str) {
    String string = str[0].toUpperCase() + str.substring(1);
    return string;
  }

  cursor(TextEditingController _controller) {
    var cursorPos = _controller.selection;
    if (cursorPos.start > _controller.text.length) {
      cursorPos = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    }
    _controller.selection = cursorPos;
  }
}
