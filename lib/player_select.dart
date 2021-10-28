import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/teams.dart';

class PlayerSelect extends StatefulWidget {
  const PlayerSelect({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  _PlayerSelectState createState() => _PlayerSelectState();
}

class _PlayerSelectState extends State<PlayerSelect> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Players'),
      ),
      body: Column(children: [
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _playerSelection(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(thickness: 8),
        const SizedBox(height: 8),
        _selectedCountInfo(context),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed:
                  (_selected.length > 1) ? () => _chooseTeams(context) : null,
              child: const Text('Find Fair Teams')),
        ]),
        const SizedBox(height: 26),
      ]),
    );
  }

  Widget _playerSelection() {
    return Column(
        children: widget.group.players
            .map((player) => CheckboxListTile(
                  title: Text(player.name),
                  secondary: player.icon(),
                  value: _selected.contains(player.id),
                  onChanged: (_) {
                    setState(() {
                      if (_selected.contains(player.id)) {
                        _selected.remove(player.id);
                      } else {
                        _selected.add(player.id);
                      }
                    });
                  },
                ))
            .toList());
  }

  Widget _selectedCountInfo(BuildContext context) {
    List<TextSpan> parts = [
      const TextSpan(text: 'Selected '),
      TextSpan(
          text: '${_selected.length}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      const TextSpan(text: ' players'),
    ];
    return RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.caption, children: parts));
  }

  void _chooseTeams(BuildContext context) {
    List<Player> players =
        widget.group.players.where((p) => _selected.contains(p.id)).toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ChooseTeams(group: widget.group, players: players),
      ),
    );
  }
}
