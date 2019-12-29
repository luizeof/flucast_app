//  detail.dart
//
//  This file is a part of the dart_pod project.
//
//  FluCast is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This porogram is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
import 'dart:ui';
import 'package:flucast_app/global.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class MyEpisodePage extends StatefulWidget {
  @override
  _MyEpisodePageState createState() => _MyEpisodePageState();
}

class _MyEpisodePageState extends State<MyEpisodePage>
    with SingleTickerProviderStateMixin {
  Future play() {
    audioPlayer.play(currentEpisode.url.toString());
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() {
    audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future seek() {
    if (isPlaying) {
      double _s = positionNum + (durationNum / 20.00);
      if (_s >= double.parse(durationNum.toString())) {
        audioPlayer.seek(durationNum);
      } else {
        audioPlayer.seek(_s);
      }
    }
  }

  Future replay() {
    if (isPlaying) {
      double _s = positionNum - (durationNum / 20.00);
      if (_s <= 0.0) {
        audioPlayer.seek(0);
      } else {
        audioPlayer.seek(_s);
      }
    }
  }

  Future stop() {
    audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Widget _buildDetail() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        Size size = MediaQuery.of(context).size;
        double progressHeight = 30;
        double minHeight = (viewportConstraints.maxHeight - progressHeight);
        double iconSize = 40;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: minHeight,
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              myPodcast.logoUrl,
                              fit: BoxFit.fitHeight,
                              width: viewportConstraints.maxWidth,
                              height: minHeight,
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 12,
                                sigmaY: 12,
                              ),
                              child: Container(
                                width: viewportConstraints.maxWidth,
                                height: minHeight,
                                color: Colors.blue.withOpacity(0.7),
                              ),
                            ),
                            Container(
                              width: size.width,
                              height: size.height,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Image.network(
                                      currentEpisode.cover,
                                      fit: BoxFit.contain,
                                      width: size.width / 2.0,
                                      height: size.width / 2.0,
                                    ),
                                    Spacer(),
                                    Text(
                                      currentEpisode.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.all(0),
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            FlatButton(
                                              child: Icon(
                                                (isPlaying == true
                                                    ? Icons.pause
                                                    : Icons.play_arrow),
                                                color: Colors.white,
                                                size: iconSize,
                                              ),
                                              onPressed: () {
                                                if (isPlaying) {
                                                  pause();
                                                } else {
                                                  play();
                                                }
                                              },
                                            ),
                                            FlatButton(
                                              child: Icon(
                                                Icons.stop,
                                                color: Colors.white,
                                                size: iconSize,
                                              ),
                                              onPressed: () {
                                                stop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Icon(
                                                Icons.forward_30,
                                                color: Colors.white,
                                                size: iconSize,
                                              ),
                                              onPressed: () {
                                                seek();
                                              },
                                            ),
                                            FlatButton(
                                              child: Icon(
                                                Icons.replay_30,
                                                color: Colors.white,
                                                size: iconSize,
                                              ),
                                              onPressed: () {
                                                replay();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Text(
                                              positionText.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Text(
                                              durationText.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: progressHeight,
                        width: viewportConstraints.maxWidth,
                        child: LinearProgressIndicator(
                          value: playerProgress(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Wrap(
                      children: [
                        Center(
                          child: Text(
                            currentEpisode.pubDate.toString(),
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          parse(
                            currentEpisode.description.toString().replaceAll(
                                  '<p>',
                                  '\n<p>',
                                ),
                          ).documentElement.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void initAudioPlayer() {
    try {
      positionSubscription = audioPlayer.onAudioPositionChanged
          .listen((p) => setState(() => position = p));
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentEpisode.title),
      ),
      body: Center(
        child: _buildDetail(),
      ),
    );
  }
}
