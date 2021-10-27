import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';

class ChooseTeams extends StatefulWidget {
  const ChooseTeams({Key? key, required this.group, required this.players})
      : super(key: key);

  final Group group;
  final List<Player> players;

  @override
  _ChooseTeamsState createState() => _ChooseTeamsState();
}

class _ChooseTeamsState extends State<ChooseTeams> {
  @override
  Widget build(BuildContext context) {
    List<Team> teams = _findTeams(widget.players);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fair Teams'),
        leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            tooltip: 'Home'),
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: teams
              .map((team) => Expanded(child: _teamColumn(context, team)))
              .toList(),
        ),
      )),
    );
  }

  Widget _teamColumn(BuildContext context, Team team) {
    List<Widget> children = [
      Text(
        team.name,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.apply(color: team.color, fontWeightDelta: 100),
      ),
      const Divider(thickness: 4),
    ];
    children += team.players.map((player) => Text(player.name)).toList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }

  List<Team> _findTeams(List<Player> players) {
    int n = (widget.players.length / 2).ceil();
    Team reds = Team(
        name: 'Reds', color: Colors.red, players: widget.players.sublist(0, n));
    Team blues = Team(
        name: 'Blues', color: Colors.blue, players: widget.players.sublist(n));
    return [reds, blues];
  }
}
