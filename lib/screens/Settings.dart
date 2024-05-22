import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;

  SettingsScreen({required this.audioPlayer});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isMusicOn = true; // 音樂開關的狀態，預設為開啟
  int _currentBackgroundIndex = 0; // 当前背景音乐索引

  @override
  void initState() {
    super.initState();
    // 根據_audioPlayer的狀態來初始化_isMusicOn
    _isMusicOn = widget.audioPlayer.state == PlayerState.playing;
  }

  // 儲存設定
  Future<void> _saveSettings() async {
    // 如果音樂是開啟的，則播放音樂；否則暫停音樂
    if (_isMusicOn) {
      widget.audioPlayer.resume();
    } else {
      widget.audioPlayer.pause();
    }
  }

  // 切換背景音樂
  void _changeBackgroundMusic() async {
    final List<String> musicList = [
      'audio/background1.mp3',
      'audio/background2.mp3',
      'audio/background3.mp3',
    ];

    try {
      // 停止当前播放的音乐
      await widget.audioPlayer.stop();
      // 播放新的背景音乐
      await widget.audioPlayer.play(AssetSource(musicList[_currentBackgroundIndex]), volume: 0.5);
    } catch (e) {
      print("Error changing background music: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), // 背景圖片
            fit: BoxFit.cover, // 圖片填滿容器
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Music: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: _isMusicOn,
                    onChanged: (value) {
                      setState(() {
                        _isMusicOn = value; // 更新音樂開關的狀態
                        _saveSettings(); // 儲存設定
                      });
                    },
                    activeColor: Colors.blue, // 開啟時的顏色
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentBackgroundIndex = (_currentBackgroundIndex + 1) % 3;
                    _changeBackgroundMusic();
                  });
                },
                child: Text('Change Background Music'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
