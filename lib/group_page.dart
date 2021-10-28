import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';
import 'package:fairteams/player_page.dart';
import 'package:fairteams/player_select.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Home'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _newPlayer(context),
              tooltip: 'New Player'),
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => null,
              tooltip: 'Edit Group'),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _playerList(context),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(thickness: 8),
        const SizedBox(height: 8),
        _countInfo(context),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed:
                (group.players.length > 1) ? () => _newGame(context) : null,
            child: const Text('New Game'),
          ),
        ]),
        const SizedBox(height: 26),
      ]),
    );
  }

  Widget _playerList(BuildContext context) {
    if (group.players.isEmpty) {
      return Column(children: [
        Text('You need to add some players!',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center)
      ]);
    } else {
      return Column(
          children: group.players
              .map((p) => ListTile(
                    title: Text(p.name),
                    leading: p.icon(),
                    trailing: p.skillDisplay(group.skillNames),
                    onTap: () => _editPlayer(context, p),
                  ))
              .toList());
    }
  }

  Widget _countInfo(BuildContext context) {
    return Consumer<AppState>(builder: (context, model, child) {
      List<TextSpan> parts = [
        const TextSpan(text: 'You have '),
        TextSpan(
            text: '${group.players.length}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: ' players to choose from'),
      ];
      return RichText(
          text: TextSpan(
              style: Theme.of(context).textTheme.caption, children: parts));
    });
  }

  void _newGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerSelect(group: group),
      ),
    );
  }

  void _newPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerPage(group: group),
      ),
    );
  }

  void _editPlayer(BuildContext context, Player player) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerPage(group: group, playerId: player.id),
      ),
    );
  }
}
