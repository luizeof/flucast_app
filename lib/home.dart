//  home.dart
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
import 'dart:async';
import 'dart:ui';
import 'package:audioplayer/audioplayer.dart';
import 'package:flucast_app/episode.dart';
import 'package:flucast_app/podcast.dart';
import 'package:usage/usage_io.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:html/parser.dart' show parse;

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Episode _episode;

  AudioPlayer audioPlayer;

  PlayerState playerState = PlayerState.stopped;

  Duration duration;

  Duration position;

  StreamSubscription positionSubscription;

  StreamSubscription audioPlayerStateSubscription;

  bool isMuted = false;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';
  get positionNum => position != null ? position.inSeconds : 0;
  get durationNum => duration != null ? duration.inSeconds : 0;

  double playerProgress() {
    try {
      if (positionNum > 0 && durationNum > 0) {
        return (((positionNum / durationNum) - 1.00)) + 1.00;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Icon episodeIcon() {
    return Icon(
      (isPlaying == true ? Icons.pause : Icons.play_arrow),
      color: Colors.green,
      size: 40,
    );
  }

  Future<AnalyticsIO> _gaSettings() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    var _packageInfo = await PackageInfo.fromPlatform();
    var _ga = new AnalyticsIO(
      GlobalConfiguration().getString("ga"),
      _packageInfo.appName.toString(),
      _packageInfo.version.toString(),
      documentDirectory: await getApplicationDocumentsDirectory(),
    );
    _ga.analyticsOpt = AnalyticsOpt.optOut;
    return _ga;
  }

  void gaRegisterScreen(String _screenName) async {
    var _ga = await _gaSettings();
    await _ga.sendScreenView(_screenName);
  }

  void gaRegisterEvent(String _eventCategory, String _eventName) async {
    var _ga = await _gaSettings();
    await _ga.sendEvent(_eventCategory, _eventName);
  }

  Future<Podcast> loadPodcast() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    return await Podcast.newFromURL(GlobalConfiguration().getString("feed"));
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    gaRegisterScreen("home");
  }

  @override
  void dispose() {
    positionSubscription.cancel();
    audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  void play() {
    audioPlayer.play(_episode.url.toString());
    setState(() {
      position = new Duration();
      duration = new Duration();
      playerState = PlayerState.playing;
    });
    gaRegisterEvent("player", "play");
  }

  void pause() {
    audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
    gaRegisterEvent("player", "pause");
  }

  void seek() {
    if (isPlaying) {
      double _s = positionNum + (durationNum / 20.00);
      if (_s >= double.parse(durationNum.toString())) {
        audioPlayer.seek(durationNum);
      } else {
        audioPlayer.seek(_s);
      }
    }
    gaRegisterEvent("player", "seek");
  }

  void replay() {
    if (isPlaying) {
      double _s = positionNum - (durationNum / 20.00);
      if (_s <= 0.0) {
        audioPlayer.seek(0);
      } else {
        audioPlayer.seek(_s);
      }
    }
    gaRegisterEvent("player", "replay");
  }

  void stop() {
    audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
      duration = new Duration();
      _episode = null;
    });
    gaRegisterEvent("player", "stop");
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
    print("mute...");
    gaRegisterEvent("player", "mute");
  }

  Widget _buildEpisodeTitle(Episode __episode) {
    if (_episode != null) {
      if (_episode.title == __episode.title) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text(
            __episode.title,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        );
      } else {
        return Text(__episode.title, softWrap: true);
      }
    } else {
      return Text(
        __episode.title,
        softWrap: true,
      );
    }
  }

  Widget _buildDefaultEpisode(Podcast __podcast, Episode __episode) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: NetworkImage(__episode.cover),
              fit: BoxFit.cover,
            ),
            title: _buildEpisodeTitle(__episode),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  __episode.pubDate.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
            onTap: () {
              setState(
                () {
                  _episode = __episode;
                },
              );
              if (isPlaying) {
                stop();
              }
              play();
            },
          ),
        ],
      ),
    );
  }

  Widget _podcastDetails(Podcast _podcast) {
    if (_podcast.runtimeType == Podcast) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          _podcast.logoUrl,
                          fit: BoxFit.fill,
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
                          Text(
                            _podcast.description.toString(),
                            style: TextStyle(fontSize: 17),
                            strutStyle: StrutStyle(
                              fontSize: 34,
                              height: .65,
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
    } else {
      return Center(
        child: Icon(
          Icons.cast,
          color: Colors.grey,
          size: 99,
        ),
      );
    }
  }

  Widget _podcatEpisodesList(Podcast _podcast) {
    int _num = (_podcast.runtimeType == Podcast ? _podcast.episodes.length : 0);

    if (_num > 0) {
      return Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder(
              itemCount: _num,
              itemBuilder: (
                BuildContext ctxt,
                int i,
              ) {
                return _buildDefaultEpisode(
                  _podcast,
                  _podcast.episodes[i],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Icon(
          Icons.list,
          color: Colors.grey,
          size: 99,
        ),
      );
    }
  }

  Widget _buildPlayEpisode(Podcast _podcast, Episode _episode) {
    gaRegisterScreen("detail");
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
                        color: Colors.blue,
                        width: size.width,
                        height: minHeight,
                        child: Stack(
                          children: <Widget>[
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
                                      _episode.cover,
                                      fit: BoxFit.contain,
                                      width: size.width / 2.0,
                                      height: size.width / 2.0,
                                    ),
                                    Spacer(),
                                    Text(
                                      _episode.title,
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
                                                setState(() {
                                                  _episode = null;
                                                });
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
                            _episode.pubDate.toString(),
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
                            _episode.description.toString().replaceAll(
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

  Widget _buildHome(Podcast _podcast) {
    if (_episode != null) {
      return _buildPlayEpisode(_podcast, _episode);
    } else {
      return TabBarView(
        children: [
          _podcastDetails(_podcast),
          _podcatEpisodesList(_podcast),
        ].toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Podcast>(
      future: loadPodcast(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Podcast> snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                    (snapshot.data.runtimeType == Podcast
                        ? snapshot.data.title
                        : "FluCast"),
                  ),
                ),
                bottom: TabBar(
                  tabs: <Tab>[
                    Tab(text: 'Sobre'),
                    Tab(text: 'Episódios'),
                  ],
                ),
              ),
              body: _buildHome(snapshot.data),
            ),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ],
          );
        } else {
          return Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
