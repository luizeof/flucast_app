import 'package:flutter/material.dart';
import 'package:flucast_app/home.dart';
import 'package:flucast_app/global.dart';
import 'package:dart_pod/dart_pod.dart';
import 'package:flucast_app/feed.dart';


Future<Podcast> loadPodcast() async {
  Podcast p = await Podcast.newFromURL(podcastFeedUrl.toString());
  return p;
}

void main() async {
  myPodcast = await loadPodcast();
  runApp(FluCastApp());
}

class FluCastApp extends StatefulWidget {
  @override
  FluCastAppState createState() => FluCastAppState();
}

class FluCastAppState extends State<FluCastApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluCast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => new MyHomePage(),
        '/detail': (context) => new MyHomePage(),
      },
    );
  }
}
