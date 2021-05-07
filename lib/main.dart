import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_radio/flutter_radio.dart';

void main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marte FM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String _url = DotEnv.env['base_url'];
  AnimationController _animationController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioStart();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  Future<void> _audioStart() async {
    try {
      await FlutterRadio.audioStart();
    } catch(error) {
      print(error);
    }
  }

  void _playToggle() {
    try {
      setState(() {
        FlutterRadio.playOrPause(url: _url);
        _isPlaying = !_isPlaying;
        if(_isPlaying)
          _animationController.forward();
        else
          _animationController.reverse();
      });
    } catch(error) {

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marte FM'),
        backgroundColor: Colors.blueGrey.shade900,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.radio,
                size: 250,
                color: Colors.white,
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white10,
                    width: 10.0
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(75))
                ),
                child: IconButton(
                  iconSize: 75,
                  splashColor: Colors.greenAccent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                    color: Colors.white,
                  ),
                  onPressed: _playToggle,
                ),
              )
            ],
          ),
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
