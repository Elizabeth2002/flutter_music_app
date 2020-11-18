import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/song_info.dart';


class SongWidget extends StatefulWidget {
  final List<SongInfo> songList;

  SongWidget({@required this.songList});

  @override
  _SongWidgetState createState() => _SongWidgetState();

  static String parseToMinutesSeconds(int ms) {
    String data;
    Duration duration = Duration(milliseconds: ms);

    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);

    data = minutes.toString() + ":";
    if (seconds <= 9) data += "0";

    data += seconds.toString();
    return data;
  }
}

class _SongWidgetState extends State<SongWidget> {

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  AudioPlayerState playerState;
  int songIndex = 0;

  Duration timeElapsed = new Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  void initPlayer(){
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
      _duration = d;
      timeElapsed = d;
    });

    advancedPlayer.positionHandler = (p) => setState(() {
      _position = p;
      timeElapsed = p;
    });

    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s){
      if (s == AudioPlayerState.COMPLETED){
        _resetPlayer();
        songIndex = songIndex == widget.songList.length - 1 ? 0 : songIndex + 1;
      }
      setState(() => playerState = s);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Card(
            elevation: 2.0,
            margin: EdgeInsets.all(5.0),
            child: FadeInImage(
              fadeInDuration: Duration(seconds: 2),
              placeholder: AssetImage( widget.songList[songIndex].image),
              image:  AssetImage( widget.songList[songIndex].image)
      )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Column(
            children: [
              Text(
                widget.songList[songIndex].songTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20,),
              Text(
                widget.songList[songIndex].artist,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _playBack(),
              _play(),
              _fastForward()
            ],
          ),
        ),
        slider(),
        _durationWidget()
      ],
    );
  }

  Widget _playBack() {
    return IconButton(
        icon: Icon(
          Icons.skip_previous,
          color: Colors.grey.shade700,
          size: 30,
        ),
        onPressed: (){
          setState(() {
            _resetPlayer();
            songIndex = songIndex == 0 ? widget.songList.length - 1 : songIndex - 1;
          });
        });
  }

  Widget _play() {
    return IconButton(
        icon: Icon(
          playerState == AudioPlayerState.PLAYING ? Icons.pause_circle_outline_outlined : Icons.play_circle_outline_outlined,
          color: Colors.grey.shade700,
          size: 40,
        ),
        onPressed: () {
          playerState == AudioPlayerState.PLAYING ? advancedPlayer.pause() : audioCache.play(widget.songList[songIndex].song);
        });
  }

  Widget _fastForward() {
    return IconButton(
        icon: Icon(
          Icons.skip_next,
          color: Colors.grey.shade700,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            _resetPlayer();
            songIndex = songIndex == widget.songList.length - 1 ? 0 : songIndex + 1;
          });
        });
  }

  Widget slider() {
    return Slider(
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });});
  }

  void seekToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    timeElapsed = newDuration;
    advancedPlayer.seek(newDuration);
  }

  void _resetPlayer() {
    _position = Duration();
    _duration = Duration();
    timeElapsed = Duration();
    advancedPlayer.stop();
  }

  Widget _durationWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
             "${timeElapsed.inMinutes.remainder(60)}:${timeElapsed.inSeconds.remainder(60)}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12
            ),
          ),
          Text(
            "${_duration.inMinutes.remainder(60)}:${_duration.inSeconds.remainder(60)}",
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12
            ),
          )
        ],
      ),
    );
  }
}
