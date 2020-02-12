import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'grafik_uang_makan.dart';
import 'larger.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  void _viewLarger() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => LargerView()));
  }

  @override
  void initState() {
    super.initState();
    try {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } on PlatformException {
      print("setPreferredOrientations FAILEEEEEEEEEEEED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(children: <Widget>[
          Container(
            width: 250,
            height: 250,
            child: GrafikUangMakan(),
          ),
          SizedBox(height: 20,),
          Text("BARS HAVE SAME HEIGHT ALTHOUGH THE VALUES ARE DIFFERENT", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          Text("Press FAB below for larger view", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
        ],),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewLarger,
        tooltip: 'View Larger',
        child: Icon(Icons.open_in_new),
      ),
    );
  }
}
