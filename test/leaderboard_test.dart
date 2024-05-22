import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/screens/Leaderboard.dart';
import 'package:tic_tac_toe/repository/player_repository.dart';


void main() {
  testWidgets('Leaderboard screen shows a list of players', (WidgetTester tester) async {
    // 构建假数据
    final fakePlayers = Future.value([
      Player(id: 'player11', wins: 11),
      Player(id: 'player22', wins: 22),
      Player(id: 'player33', wins: 33),
    ]);

    // 构建 LeaderboardScreen Widget，并提供假数据
    await tester.pumpWidget(MaterialApp(
      home: LeaderboardScreen(players: fakePlayers),
    ));

    // 等待 FutureBuilder 完成并重建 Widget 树
    await tester.pumpAndSettle();

    // 验证玩家列表是否正确显示
    expect(find.text('player11'), findsOneWidget);
    expect(find.text('player22'), findsOneWidget);
    expect(find.text('player33'), findsOneWidget);

  });
}
