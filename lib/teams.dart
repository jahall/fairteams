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
  late Team _reds;
  late Team _blues;

  @override
  void initState() {
    super.initState();
    var teams = _findTeams(widget.players);
    _reds = teams[0];
    _blues = teams[1];
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(children: [
                _header(context, "Teams"),
                const SizedBox(height: 4),
                const Divider(thickness: 3),
                const SizedBox(height: 8),
                _teamHeader(context),
                const SizedBox(height: 2),
                _teamColumns(context),
                const SizedBox(height: 24),
                _header(context, "Analysis"),
                const SizedBox(height: 4),
                const Divider(thickness: 3),
                const SizedBox(height: 8),
                _teamComparison(context),
              ]))),
    );
  }

  Widget _header(BuildContext context, String title) {
    final style = Theme.of(context).textTheme.headline6;
    return Row(children: [Expanded(child: Text(title, style: style))]);
  }

  Widget _teamHeader(BuildContext context) {
    var style =
        Theme.of(context).textTheme.bodyText2?.apply(fontWeightDelta: 100);
    return Row(children: [
      Expanded(
          // required to make the columns fill the row
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Reds", style: style?.apply(color: _reds.color)))),
      const SizedBox(width: 16),
      Expanded(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Blues", style: style?.apply(color: _blues.color)))),
    ]);
  }

  Widget _teamColumns(BuildContext context) {
    var redsList = _reds.players
        .map((player) => Row(children: [
              Expanded(
                  child: ListTile(
                      title: Text(player.name),
                      subtitle: player.skillDisplay(widget.group.skillNames),
                      trailing: IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () => setState(() {
                                _reds.remove(player);
                                _blues.add(player);
                              }),
                          tooltip: 'Transfer'))),
            ]))
        .toList();
    var bluesList = _blues.players
        .map((player) => Row(children: [
              Expanded(
                  child: ListTile(
                      title: Text(player.name),
                      subtitle: player.skillDisplay(widget.group.skillNames),
                      trailing: IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () => setState(() {
                                _blues.remove(player);
                                _reds.add(player);
                              }),
                          tooltip: 'Transfer'))),
            ]))
        .toList();
    return Row(children: [
      _boxed(Column(children: redsList), Colors.redAccent),
      const SizedBox(width: 16),
      _boxed(Column(children: bluesList), Colors.blueAccent),
    ]);
  }

  Widget _teamComparison(BuildContext context) {
    return Column(
        children:
            widget.group.skillNames.map((s) => _skillRow(context, s)).toList());
  }

  Widget _skillRow(BuildContext context, String skillName) {
    var redSkill = _reds.skill(skillName);
    var blueSkill = _blues.skill(skillName);
    var diff = redSkill - blueSkill;
    final style =
        Theme.of(context).textTheme.bodyText1?.apply(fontSizeDelta: 1);

    Widget scoreView(double score, Color color, bool bold) {
      return Text(redSkill.toStringAsFixed(1),
          style: style?.apply(color: color, fontWeightDelta: (bold) ? 50 : 0));
    }

    Widget diffView(bool show) {
      return SizedBox(
          child: Align(
              alignment: Alignment.center,
              child: Text((show) ? '+${diff.abs().toStringAsFixed(1)}' : '',
                  style: style?.apply(color: Colors.green))),
          width: 50);
    }

    return SizedBox(
        height: 22,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          diffView(diff > 0.05),
          scoreView(redSkill, Colors.red, diff > 0.05),
          SizedBox(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(skillName, style: style)),
              width: 150),
          scoreView(blueSkill, Colors.blue, diff < -0.05),
          diffView(diff < -0.05),
        ]));
  }

  Widget _boxed(Widget child, Color color) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              border: Border.all(color: color, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            ),
            child: child));
  }

  List<Team> _findTeams(List<Player> players) {
    int n = (players.length / 2).ceil();
    Team reds =
        Team(name: 'Reds', color: Colors.red, players: players.sublist(0, n));
    Team blues =
        Team(name: 'Blues', color: Colors.blue, players: players.sublist(n));
    return [reds, blues];
  }
}
