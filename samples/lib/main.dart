import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  Widget _cardA() {
    var baseHeight = MediaQuery.of(context).size.height.toDouble();
    var baseWidth = MediaQuery.of(context).size.width.toDouble();

    return Container(
      height: baseHeight / 2,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.black,
        elevation: 10,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Center(
              child: Image.network(
                  "http://images.pexels.com/photos/3249431/pexels-photo-3249431.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=940&h=940&crop=1",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context)
                      .size
                      .width // contains width and height,
                  ),
            ),
            new Center(
              child: new ClipRect(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    subtitle: Container(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'TWICE',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            backgroundColor: Colors.red,
                            fontFamily: "Roboto",
                            color: Colors.white,
                            fontSize: baseWidth * 0.045,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Heart Shaker long line crp text long line croped cliped text title of article',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: baseWidth * 0.065,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(7.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Card A"),
      ),
      body: Column(
        children: [
          _cardA(),
        ],
      ),
    );
  }
}
