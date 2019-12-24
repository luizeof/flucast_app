import 'package:flutter/material.dart';
import 'package:flucast_app/home.dart';
import 'package:flucast_app/global.dart';
import 'package:dart_pod/dart_pod.dart';

void main() async => runApp(FluCastApp());

class FluCastApp extends StatelessWidget {
  _initPodcast() async {
    myPodcast = await Podcast.newFromURL(feed_url);
    episodes = myPodcast.episodes.toList();
  }

  @override
  Widget build(BuildContext context) {
    _initPodcast();
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
