import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/player_page.dart';
import 'package:fairteams/player_select.dart';

class GroupPage extends StatefulWidget {
  const GroupPage(
      {Key? key,
      required this.group,
      required this.addPlayer,
      required this.replacePlayer,
      required this.removePlayer})
      : super(key: key);

  final Group group;
  final void Function(Group group, Player player) addPlayer;
  final void Function(Group group, Player player, int index) replacePlayer;
  final void Function(Group group, int index) removePlayer;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
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
              child: Column(
                children: _playerList(context),
              ),
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
            onPressed: () => _newGame(context),
            child: const Text('New Game'),
          ),
        ]),
        const SizedBox(height: 26),
      ]),
    );
  }

  List<Widget> _playerList(BuildContext context) {
    if (widget.group.players.isEmpty) {
      return [
        Text('You need to add some players!',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center)
      ];
    } else {
      return widget.group.players
          .asMap()
          .entries
          .map((entry) => ListTile(
                title: Text(entry.value.name),
                leading: entry.value.icon(),
                trailing: entry.value.skillDisplay(widget.group.skillNames),
                onTap: () => _editPlayer(context, entry.key),
              ))
          .toList();
    }
  }

  Widget _countInfo(BuildContext context) {
    List<TextSpan> parts = [
      const TextSpan(text: 'You have '),
      TextSpan(
          text: '${widget.group.players.length}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      const TextSpan(text: ' players to choose from'),
    ];
    return RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.caption, children: parts));
  }

  void _newGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerSelect(group: widget.group),
      ),
    );
  }

  void _newPlayer(BuildContext context) async {
    Player emptyPlayer = Player();
    Player? player = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PlayerPage(group: widget.group, player: emptyPlayer),
      ),
    );
    if (player != null) {
      setState(() => widget.addPlayer(widget.group, player));
    }
  }

  void _editPlayer(BuildContext context, int index) async {
    Player oldPlayer = widget.group.players[index];
    Player? newPlayer = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PlayerPage(group: widget.group, player: oldPlayer, mode: 'edit'),
      ),
    );
    if (newPlayer?.name == 'DELETE') {
      setState(() => widget.removePlayer(widget.group, index));
    } else if (newPlayer != null) {
      setState(() => widget.replacePlayer(widget.group, newPlayer, index));
    }
  }
}
