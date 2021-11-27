// ignore_for_file: file_names, prefer_const_constructors, unnecessary_this, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'language.dart';

class TranslateInput extends StatefulWidget {
  TranslateInput(
      {Key? key,
        required this.onCloseClicked,
        required this.focusNode,
        required this.firstLanguage,
        required this.secondLanguage})
      : super(key: key);

  final Function(bool) onCloseClicked;
  final FocusNode focusNode;
  final Language firstLanguage;
  final Language secondLanguage;


  @override
  _TranslateInputState createState() => _TranslateInputState();
}

class _TranslateInputState extends State<TranslateInput> {
  TextEditingController _textEditingController = TextEditingController();
  String _textTranslated = "";
  GoogleTranslator _translator = new GoogleTranslator();

  _onTextChanged(String text) {
    if (text != "") {
      _translator
          .translate(text,
          from: this.widget.firstLanguage.code,
          to: this.widget.secondLanguage.code)
          .then((translatedText) {
        this.setState(() {
          this._textTranslated = translatedText.toString();
        });
      });
    } else {
      this.setState(() {
        this._textTranslated = "";
      });
    }
  }

  TextEditingController input = TextEditingController();
  TextEditingController output = TextEditingController();


  Future insertdata() async {
    final response = await http.post(Uri.parse(
        "http://192.168.0.166/localconnect/insertdata.php"), body: {
      "_textEditingController": input.text,
      "_textTranslated": output.text,

    });

    @override
    Widget build(BuildContext context) {
      return Container(
        height: 150.0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: TextField(
                  focusNode: this.widget.focusNode,
                  controller: this._textEditingController,
                  onChanged: this._onTextChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: RawMaterialButton(
                      onPressed: () {
                        if (this._textEditingController.text != "") {
                          this.setState(() {
                            this._textEditingController.clear();
                            this._textTranslated = "";
                          });
                        } else {
                          this.widget.onCloseClicked(false);
                        }
                      },
                      child: new Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      shape: new CircleBorder(),
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    this._textTranslated,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
