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
        const SizedBox(height: 24),
        _selectedCountInfo(context),
        const SizedBox(height: 12),
        const Divider(thickness: 2),
        const SizedBox(height: 6),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _playerSelection(),
            ),
          ),
        ),
      ]),
      floatingActionButton: Visibility(
          visible: (_selected.length > 1),
          child: FloatingActionButton.extended(
            onPressed: () => _chooseTeams(context),
            label: const Text('Choose Teams'),
          )),
    );
  }

  Widget _playerSelection() {
    var width = MediaQuery.of(context).size.width - 16 * 2;
    List<Widget> fields = widget.group.players
        .map<Widget>((p) => SizedBox(
              width: width,
              height: 35,
              child: Row(children: [
                SizedBox(width: 50, child: p.icon(color: Colors.blue)),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft, child: Text(p.name))),
                p.abilityDisplay(widget.group.skills, color: Colors.blue),
                SizedBox(
                    width: 50,
                    child: Checkbox(
                        value: _selected.contains(p.id),
                        onChanged: (_) {
                          setState(() {
                            if (_selected.contains(p.id)) {
                              _selected.remove(p.id);
                            } else {
                              _selected.add(p.id);
                            }
                          });
                        })),
              ]),
            ))
        .toList();
    return Column(children: fields + <Widget>[const SizedBox(height: 64)]);
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
