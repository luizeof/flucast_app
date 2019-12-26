import 'package:audioplayer/audioplayer.dart';
import 'package:flucast_app/global.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class MyEpisodePage extends StatefulWidget {
  @override
  _MyEpisodePageState createState() => _MyEpisodePageState();
}

class _MyEpisodePageState extends State<MyEpisodePage>
    with SingleTickerProviderStateMixin {
  Future play() async {
    await audioPlayer.play(currentEpisode.url.toString());
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future seek() async {
    double _s = positionNum + 30.0;
    if (_s >= double.parse(durationNum.toString())) {
      await audioPlayer.seek(durationNum);
    } else {
      await audioPlayer.seek(_s);
    }
  }

  Future replay() async {
    double _s = positionNum - 30.0;
    if (_s <= 0.0) {
      await audioPlayer.seek(0);
    } else {
      await audioPlayer.seek(_s);
    }
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Widget _buildDetail() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        myPodcast.logoUrl,
                        fit: BoxFit.fill,
                      ),
                      LinearProgressIndicator(
                        value: playerProgress(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Text(
                                positionText.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey,
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
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                        Center(
                          child: Text(
                            currentEpisode.pubDate.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Text(
                            currentEpisode.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                            strutStyle: StrutStyle(
                              fontSize: 34,
                              height: .65,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            (isPlaying == true
                                ? Icons.pause
                                : Icons.play_arrow),
                            color: Colors.blue,
                            size: 33,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              pause();
                            } else {
                              play();
                            }
                            setState() {}
                          },
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.stop,
                            color: Colors.blue,
                            size: 33,
                          ),
                          onPressed: () {
                            stop();
                            setState() {}
                          },
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.forward_30,
                            color: Colors.blue,
                            size: 33,
                          ),
                          onPressed: () {
                            seek();
                            setState() {}
                          },
                        ),
                        FlatButton(
                          child: Icon(
                            Icons.replay_30,
                            color: Colors.blue,
                            size: 33,
                          ),
                          onPressed: () {
                            replay();
                            setState() {}
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
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
    positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen(
      (s) {
        if (s == AudioPlayerState.PLAYING) {
          setState(() => duration = audioPlayer.duration);
        } else if (s == AudioPlayerState.STOPPED) {
          setState(
            () {
              position = duration;
            },
          );
        }
      },
      onError: (msg) {
        setState(
          () {
            playerState = PlayerState.stopped;
            duration = new Duration(seconds: 0);
            position = new Duration(seconds: 0);
          },
        );
      },
    );
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
