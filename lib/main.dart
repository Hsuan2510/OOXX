import 'package:flutter/material.dart';
import 'package:tic_tac_toe/repository/player_repository.dart';
import 'package:tic_tac_toe/screens/Home.dart';
import 'package:tic_tac_toe/screens/Leaderboard.dart';
import 'package:tic_tac_toe/screens/Settings.dart';
import 'package:tic_tac_toe/screens/Game.dart'; // 导入游戏页面
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late AudioPlayer _audioPlayer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    try {
      await _audioPlayer.play(AssetSource('audio/background1.mp3'), volume: 0.5);
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = <Widget>[
      HomeScreen(),
      LeaderboardScreen(players: PlayerRepository().fetchPlayers()),
      SettingsScreen(audioPlayer: _audioPlayer),
      GameScreen(player1: 'Player 1', player2: 'Player 2'),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.5), // 设置上方背景为半透明黑色
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _screens,
            ),
          ),
          Positioned(
            bottom: 0, // 将底部容器放置在底部
            left: 0, // 将底部容器放置在左侧
            right: 0, // 将底部容器放置在右侧
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'), // 使用背景图片
                  fit: BoxFit.cover, // 设置图片填充方式为覆盖
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.black.withOpacity(0.5), // 设置底部导航栏的半透明黑色背景
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: Colors.white),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.leaderboard, color: Colors.white),
                    label: 'Leaderboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings, color: Colors.white),
                    label: 'Settings',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Colors.white, // 设置选中项的颜色为白色
                unselectedItemColor: Colors.grey, // 设置未选中项的颜色为灰色
                selectedLabelStyle: TextStyle(color: Colors.white), // 设置选中标签文本的样式为白色
                unselectedLabelStyle: TextStyle(color: Colors.grey), // 设置未选中标签文本的样式为灰色
              ),
            ),
          ),
        ],
      ),
    );
  }
}
