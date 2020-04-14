import 'package:flutter/material.dart';

class ClearTextField extends StatefulWidget {
  @override
  ClearTextFieldState createState() {
    return new ClearTextFieldState();
  }
}

class ClearTextFieldState extends State<ClearTextField> {
  TextEditingController _textFieldController = TextEditingController();

  _onClear() {
    setState(() {
      _textFieldController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        //Add padding around textfield
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          controller: _textFieldController,
          decoration: InputDecoration(
            suffix: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: _onClear,
            ),
          ),
        ),
      ),
    );
  }
}
