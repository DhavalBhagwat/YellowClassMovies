import 'dart:io';
import 'package:app/data/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/utils/lib.dart';
import 'package:app/ui/lib.dart';
import 'package:app/services/lib.dart';

class MoviesFormActivity extends StatefulWidget {

  const MoviesFormActivity({
    Key? key,
  }) : super(key: key);

  @override
  _MoviesFormActivityState createState() => _MoviesFormActivityState();

}

class _MoviesFormActivityState extends State<MoviesFormActivity> {

  static const String _TAG = "MoviesFormActivity";
  TextEditingController? _nameController, _directorController;
  XFile? _image;
  bool? _isEdit, _isSame;
  int? _id;
  String? _imagePath;
  Future<void>? _initialize;

  @override
  void initState() {
    super.initState();
    _initialize = _init();
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
        body: FutureBuilder<void>(
          future: _initialize,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) return Container(
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
            ); else return LoadingIndicator();
          }
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

  Future<void> _init() async {
    try {
      _isEdit = Get.arguments["isEdit"];
      if (_isEdit!) {
        await DataService.getInstance.getMovie(Get.arguments["id"]).then((movie) async{
          print(movie.toJson());
          _id = movie.id;
          _nameController = TextEditingController(text: movie.name);
          _directorController = TextEditingController(text: movie.director);
          _imagePath = movie.poster;
        });
      } else {
        _nameController = TextEditingController();
        _directorController = TextEditingController();
      }
    } catch (error) {
      Logger.getInstance.e(_TAG, "init()", message: error.toString());
    }
  }

  dynamic _loadImage() {
    print(_imagePath);
    if (_isEdit!) return FileImage(File.fromUri(Uri.parse(_imagePath!)));
    else return _image != null ? FileImage(File.fromUri(Uri.parse(_image!.path))) : AssetImage(Assets.DEFAULT_IMAGE);
  }

  void _getImage() async {
    await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 25).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  String? _getImagePath() {
    if (_image?.path == null) {
      _isSame = true;
      return _imagePath;
    } else {
      _isSame = false;
      return _image?.path;
    }
  }

  void _onClick() {
    if (_isEdit!) DataService.getInstance.editMovie(Movie(id:_id, name: _nameController?.value.text, director: _directorController?.value.text, poster: _getImagePath()), _isSame!);
    else DataService.getInstance.addMovie(name: _nameController?.value.text, director: _directorController?.value.text, poster: _image!.path);
  }

}
