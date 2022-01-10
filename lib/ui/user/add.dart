import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/net/request_state.dart';
import 'package:todo/ui/user/add_vm.dart';
import 'package:todo/ui/user/select.dart';
import 'package:todo/utils/request_dialog.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<AddViewModel>(context, listen: false);
    vm.resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddViewModel>(builder: (context, viewModel, child) {
      return _widget(context, viewModel);
    });
  }

  Widget _widget(BuildContext context, AddViewModel viewModel) {
    if (viewModel.state?.requestStatus == RequestStatus.error) {
      Future.delayed(Duration.zero, () async {
        return RequestDialog.show(context, viewModel.state!.error.toString());
      });
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    TextStyle animatedTextStyle =
        GoogleFonts.inter(fontSize: width / 10, fontWeight: FontWeight.w200);
    return SizedBox(
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: height / 18),
            SizedBox(height: height / 18),
            Text("ADD TODO", style: GoogleFonts.poppins(fontSize: width / 10)),
            SizedBox(height: height / 20),
            SizedBox(
              width: width / 1.15,
              child: TextFormField(
                controller: titleController,
                style: GoogleFonts.raleway(fontSize: width / 20),
                decoration: InputDecoration(
                    label: Text(
                      "Title",
                      style: GoogleFonts.raleway(fontSize: height / 40),
                    ),
                    prefixIcon: const Icon(FontAwesomeIcons.heading)),
              ),
            ),
            SizedBox(height: height / 20),
            SizedBox(
              width: width / 1.15,
              child: TextFormField(
                controller: descriptionController,
                maxLines: 10 * 10,
                minLines: 1,
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
            SizedBox(height: height / 10),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffcc2b5e), Color(0xff753a88)],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              height: height / 16,
              width: width / 2.5,
              child: TextButton(
                onPressed: () async {
                  bool s = await viewModel.create(
                      titleController.text, descriptionController.text);
                  if (s == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectPage()),
                        (route) => false);
                  }
                },
                child: Text(
                  "ADD",
                  style: GoogleFonts.ptSans(
                      color: Colors.white, fontSize: width / 18),
                ),
              ),
            ),
            SizedBox(height: height / 50),
            AnimatedTextKit(
              animatedTexts: [
                RotateAnimatedText(
                  'Complete Project?',
                  textStyle: animatedTextStyle,
                  duration: const Duration(milliseconds: 1500),
                ),
                RotateAnimatedText(
                  'Play Games?',
                  textStyle: animatedTextStyle,
                  duration: const Duration(milliseconds: 1500),
                ),
                RotateAnimatedText(
                  'Buy Vegetables?',
                  textStyle: animatedTextStyle,
                  duration: const Duration(milliseconds: 1500),
                ),
                RotateAnimatedText(
                  'Add Anything',
                  textStyle: animatedTextStyle,
                  duration: const Duration(milliseconds: 1500),
                ),
                RotateAnimatedText(
                  'Animish Sharma',
                  textStyle: animatedTextStyle,
                  duration: const Duration(milliseconds: 1500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
