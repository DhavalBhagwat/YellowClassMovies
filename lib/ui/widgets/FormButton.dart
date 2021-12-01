import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/lib.dart';

class FormButton extends StatelessWidget {

  final BuildContext? context;
  final String? label;
  final Function? onPressed;

  FormButton({
    Key? key,
    @required this.context,
    @required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)
        ),
      ),
      child: MaterialButton(
          color: AppTheme.colorPrimary,
          highlightColor: AppTheme.transparent,
          shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(20.0)
          ),
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 42.0
            ),
            child: Text(
              label!,
            ),
          ),
          onPressed: () => onPressed!()
      ),
    );
  }

}