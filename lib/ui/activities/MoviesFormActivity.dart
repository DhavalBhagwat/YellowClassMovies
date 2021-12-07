import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/utils/lib.dart';
import 'package:app/ui/lib.dart';
import 'package:app/data/lib.dart';
import 'package:app/services/lib.dart';

class MoviesFormActivity extends StatefulWidget {

  const MoviesFormActivity({
    Key? key,
  }) : super(key: key);

  @override
  _MoviesFormActivityState createState() => _MoviesFormActivityState();

}

class _MoviesFormActivityState extends State<MoviesFormActivity> {

  TextEditingController? _nameController, _directorController;
  Logger? _logger;
  XFile? _image;
  Movie? _movie;
  bool? _isEdit;
  int? _id;

  @override
  void initState() {
    super.initState();
    _logger = Logger.getInstance;
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        resizeToAvoidBottomInset: false,
        appBar: CupertinoNavigationBar(
          backgroundColor: AppTheme.white,
          middle: _isEdit! ? Text("Edit Movie") : Text("Add Movie"),
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.colorAccent,
            ),
            onTap: () => NavigationService.getInstance.dashboardActivity(),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(25.0),
          child: Column(
            children: [
              _getPageHeader(context),

              SizedBox(height: 20.0),

              _getTextInput(context, "Movie Name", _nameController),

              SizedBox(height: 20.0),

              _getTextInput(context, "Director", _directorController),

              SizedBox(height: 20.0),

              _getSubmitButton(context, _isEdit! ? "Update" : "Add", () => _onClick()),

            ],
          ),
        ),
      ),
      onWillPop: () => NavigationService.getInstance.dashboardActivity()
    );
  }

  Widget _getPageHeader(BuildContext context) => InkWell(
    child: Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: _loadImage()
        ),
      ),
    ),
    onTap: () => _getImage(),
  );

  Widget _getTextInput(BuildContext context, String label, TextEditingController? controller) => FormTextInput(
    context: context,
    hint: label,
    controller: controller,
  );

  Widget _getSubmitButton(BuildContext context, String label, Function onPressed) => FormButton(
    context: context,
    label: label,
    onPressed: onPressed
  );

  void _init() {
    _isEdit = Get.arguments["isEdit"];
    _id = Get.arguments["id"];
    _nameController = TextEditingController();
    _directorController = TextEditingController();
  }

  dynamic _loadImage() => _image != null ? FileImage(File.fromUri(Uri.parse(_image!.path))) : AssetImage(Assets.DEFAULT_IMAGE);

  void _getImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 25).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  void _onClick() {
    if (_isEdit!) DataService.getInstance.editMovie(id: _id, name: _nameController?.value.text, director: _directorController?.value.text, poster: _image!.path);
    else DataService.getInstance.addMovie(name: _nameController?.value.text, director: _directorController?.value.text, poster: _image!.path);
  }

}
