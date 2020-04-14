import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'widgets/clear_textfield.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thermal TTY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, brightness: Brightness.dark),
      home: MyHomePage(title: 'Thermal TTY Communicator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _textFieldController,
                onChanged: (String value) {
                  text = value;
                  print(text);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Text to send to printer',
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                color: Colors.cyanAccent,
                textColor: Colors.black,
                onPressed: () {
                  sendToPrinter(text);
                  _clear();
                },
                child: Text('Send', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: () {
          getStatus(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.print),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  _clear() {
    setState(() {
      _textFieldController.text = '';
      text = '';
    });
  }
}

// class ClearTextField extends StatefulWidget {
//   @override
//   ClearTextFieldState createState() {
//     return new ClearTextFieldState();
//   }
// }

Future<void> getStatus(BuildContext context) async {
  http.Response response = await http.get('https://tty.vagn.es/api/test/');

  String statusText;

  if (response.statusCode == 200) {
    statusText = 'Server is alive';
  } else {
    statusText = 'Server is kill';
  }
  var alertDialog =
      AlertDialog(title: Text('Server status'), content: Text(statusText));

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

Future<void> sendToPrinter(input) async {
  Map data = {'user_input': '$input'};
  var body = json.encode(data);
  http.post('https://tty.vagn.es/api/print_text/',
      headers: {"Content-Type": "application/json"}, body: body);
}
