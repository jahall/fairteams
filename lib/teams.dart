import 'dart:math';
import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/utils.dart';

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
  late List<Player> _optimalRedPlayers;
  late List<Player> _optimalBluePlayers;

  @override
  void initState() {
    super.initState();
    var teams = _findTeams(widget.players);
    _reds = teams[0];
    _blues = teams[1];
    _optimalRedPlayers = List.from(_reds.players);
    _optimalBluePlayers = List.from(_blues.players);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Fair Teams'), actions: [
          IconButton(
              icon: const Icon(Icons.rotate_left),
              onPressed: _revertToOptimal,
              tooltip: 'Revert Teams'),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  tooltip: 'Home')),
        ]),
        body: Box(
            child: Scrollbar(
                child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 16),
            _teamHeader(context),
            const SizedBox(height: 2),
            _teamColumns(context),
            const Divider(thickness: 2),
            const SizedBox(height: 8),
            _teamComparison(),
          ]),
        ))));
  }

  void _revertToOptimal() {
    setState(() {
      _reds.players = List.from(_optimalRedPlayers);
      _blues.players = List.from(_optimalBluePlayers);
    });
  }

  // TEAM DISPLAY **********************************************************

  Widget _teamHeader(BuildContext context) {
    var style =
        Theme.of(context).textTheme.bodyText2?.apply(fontWeightDelta: 100);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Expanded(
              // required to make the columns fill the row
              child: Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("Reds", style: style?.apply(color: _reds.color)))),
          const SizedBox(width: 16),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text("Blues", style: style?.apply(color: _blues.color)))),
        ]));
  }

  Widget _teamColumns(BuildContext context) {
    var optimalReds = _optimalRedPlayers.map((p) => p.id).toSet();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          for (int i = 0;
              i < max(_reds.players.length, _blues.players.length);
              i += 1)
            // This row has unbounded width so its children cant be expanded
            // therefore passing width down...sure there's a better way!
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              (i < _reds.players.length)
                  ? Expanded(
                      child: PlayerTile(
                          group: widget.group,
                          player: _reds.players[i],
                          swapIcon: const Icon(Icons.keyboard_arrow_right,
                              color: Colors.grey),
                          color: (optimalReds.contains(_reds.players[i].id))
                              ? Colors.red
                              : Colors.blue,
                          onSwap: () => setState(() {
                                _blues.add(_reds.players[i]);
                                _blues.sort(widget.group.skills);
                                _reds.remove(_reds.players[i]);
                                _reds.sort(widget.group.skills);
                              })))
                  : const Expanded(child: Text('')),
              const SizedBox(width: 16),
              (i < _blues.players.length)
                  ? Expanded(
                      child: PlayerTile(
                          group: widget.group,
                          player: _blues.players[i],
                          swapIcon: const Icon(Icons.keyboard_arrow_left,
                              color: Colors.grey),
                          color: (optimalReds.contains(_blues.players[i].id))
                              ? Colors.red
                              : Colors.blue,
                          onSwap: () => setState(() {
                                _reds.add(_blues.players[i]);
                                _reds.sort(widget.group.skills);
                                _blues.remove(_blues.players[i]);
                                _blues.sort(widget.group.skills);
                              })))
                  : const Expanded(child: Text('')),
            ])
        ]));
  }

  // TEAM COMPARISON ********************************************************

  Widget _teamComparison() {
    double d =
        max(_reds.players.length.toDouble(), _blues.players.length.toDouble());
    var redOverall = _reds.overallAbility(widget.group.skills, denominator: d);
    var blueOverall =
        _blues.overallAbility(widget.group.skills, denominator: d);
    var overall = SkillRow(
        skillName: 'Overall', redAbility: redOverall, blueAbility: blueOverall);
    var breakdown = widget.group.skills.map((s) => _skillRow(s, d)).toList();
    return Column(
        children: <Widget>[overall, const Divider(thickness: 2)] + breakdown);
  }

  Widget _skillRow(Skill skill, double denominator) {
    var rAbility = _reds.ability(skill, denominator: denominator);
    var bAbility = _blues.ability(skill, denominator: denominator);
    return SkillRow(
        skillName: skill.name, redAbility: rAbility, blueAbility: bAbility);
  }

  // TEAM FINDING ***********************************************************

  List<Team> _findTeams(List<Player> players) {
    int n = (players.length / 2).ceil();
    Team reds = Team();
    Team blues = Team();
    double diff = 1.0 / 0.0; // infinity
    for (var redPlayers in combinations(n, players)) {
      var redIds = redPlayers.map((p) => p.id).toSet();
      var reds_ = Team(name: 'Reds', color: Colors.red, players: redPlayers);
      var blues_ = Team(
          name: 'Blues',
          color: Colors.blue,
          players: players.where((p) => !redIds.contains(p.id)).toList());
      var diff_ = reds_.diff(blues_, widget.group.skills);
      if (diff_ < diff) {
        reds = reds_;
        blues = blues_;
        diff = diff_;
      }
    }
    reds.sort(widget.group.skills);
    blues.sort(widget.group.skills);
    return [reds, blues];
  }
}

class PlayerTile extends StatelessWidget {
  const PlayerTile(
      {Key? key,
      required this.group,
      required this.player,
      required this.color,
      required this.swapIcon,
      this.onSwap})
      : super(key: key);

  final Group group;
  final Player player;
  final Color color;
  final Icon swapIcon;
  final void Function()? onSwap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Align(
                    alignment: Alignment.centerLeft, child: Text(player.name)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: player.abilityDisplay(group.skills, color: color)),
              ])),
          IconButton(icon: swapIcon, onPressed: onSwap, tooltip: 'Transfer'),
        ]));
  }
}

class SkillRow extends StatelessWidget {
  const SkillRow(
      {Key? key,
      required this.skillName,
      required this.redAbility,
      required this.blueAbility})
      : super(key: key);

  final String skillName;
  final double redAbility;
  final double blueAbility;

  @override
  Widget build(BuildContext context) {
    var ra = (100 * redAbility).round() / 100;
    var ba = (100 * blueAbility).round() / 100;
    var diff = ra - ba;
    final style = Theme.of(context).textTheme.bodyText1;

    Widget scoreView(double score, Color color, bool bold) {
      return SizedBox(
          child: Align(
              alignment: Alignment.center,
              child: Text(score.toStringAsFixed(2),
                  style: style?.apply(
                      color: color, fontWeightDelta: (bold) ? 50 : 0))),
          width: 40);
    }

    Widget diffView(bool show) {
      return SizedBox(
          child: Align(
              alignment: Alignment.center,
              child: Text((show) ? '+${diff.abs().toStringAsFixed(2)}' : '',
                  style: style?.apply(color: Colors.green))),
          width: 60);
    }

    return SizedBox(
        height: 22,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          diffView(diff > 0.005),
          scoreView(ra, Colors.red, diff > 0.005),
          SizedBox(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(skillName, style: style)),
              width: 120),
          scoreView(ba, Colors.blue, diff < -0.005),
          diffView(diff < -0.005),
        ]));
  }
}

Iterable<List<T>> combinations<T>(int k, List<T> items) sync* {
  if (k == 0) {
    yield [];
  } else {
    for (var i = 0; i < items.length; i++) {
      for (var suffix in combinations(k - 1, items.sublist(i + 1))) {
        yield [items[i]] + suffix;
      }
    }
  }
}
