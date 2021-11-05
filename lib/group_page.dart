import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';
import 'package:fairteams/group_edit.dart';
import 'package:fairteams/player_edit.dart';
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
              onPressed: () => _editGroup(context),
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
        const SizedBox(height: 24),
        _countInfo(context),
        const SizedBox(height: 24),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (group.players.length > 1) ? () => _newGame(context) : null,
        label: const Text('New Game'),
      ),
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
                    trailing: p.skillDisplay(Colors.blue, group.skillNames),
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
        builder: (context) => PlayerEdit(group: group),
      ),
    );
  }

  void _editGroup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupEdit(group: group),
      ),
    );
  }

  void _editPlayer(BuildContext context, Player player) async {
    String? action = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerEdit(group: group, player: player),
      ),
    );

    // If you try to do this on the player_edit page it doesn't work
    // since the navigator pop messes with context and causes a null...
    if (action == 'delete') {
      final snackBar = SnackBar(
        content: Text(
            'Are you sure you want to remove ${player.name} from ${group.name}?'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            Provider.of<AppState>(context, listen: false)
                .addOrUpdatePlayer(group.id, player);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
