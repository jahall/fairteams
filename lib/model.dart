import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Group {
  late final String id;
  String name;
  String sport;
  late List<String> skillNames; // late allows null in constructor
  late Map<String, Player> _players;

  Group({id, this.name = '', this.sport = '', skillNames, players}) {
    // For time based could use DateTime.now().millisecondsSinceEpoch
    this.id = (id == null) ? Uuid().v4() : id;
    this.skillNames = (skillNames == null) ? [] : skillNames;
    _players = (players == null) ? {} : {for (var p in players) p.id: p};
  }

  Player player(String id) {
    return _players[id]!;
  }

  UnmodifiableListView<Player> get players {
    // List of players sorted by name
    List<Player> playersList = _players.entries.map((e) => e.value).toList();
    playersList.sort(
        (g1, g2) => g1.name.toLowerCase().compareTo(g2.name.toLowerCase()));
    return UnmodifiableListView(playersList);
  }

  void addOrUpdatePlayer(Player player) => _players[player.id] = player;
  void removePlayer(String id) => _players.remove(id);

  String subtitle() {
    return sport.toTitleCase() + ': ' + players.length.toString() + ' players';
  }

  Icon icon() {
    IconData? iconData = {
      'basketball': Icons.sports_basketball,
      'football': Icons.sports_soccer,
    }[sport.toLowerCase()];
    return Icon(iconData);
  }
}

class Player {
  late final String id;
  String name;
  late Map<String, double> skills;

  Player({id, this.name = '', skills}) {
    this.id = (id == null) ? Uuid().v4() : id;
    this.skills = (skills == null) ? {} : skills;
  }

  Icon icon({Color? color}) {
    if (color != null) {
      return Icon(Icons.person, color: color);
    } else {
      return const Icon(Icons.person);
    }
  }

  Widget skillDisplay(List<String> skillNames) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: skillNames
          .map((skillName) => Icon(Icons.circle,
              color: skillColor(skills[skillName] ?? 5.0), size: 12.0))
          .toList(),
    );
  }
}

Color? skillColor(double value) {
  // Could try Colors.lerp for linear interpolation between values
  if (value > 8.5) {
    return Colors.green;
  } else if (value > 6.5) {
    return Colors.lightGreen;
  } else if (value > 4.5) {
    return Colors.amber;
  } else if (value > 2.5) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

class Team {
  String name;
  Color? color;
  late List<Player> players;

  Team({this.name = '', this.color, players}) {
    this.players = (players == null) ? [] : players;
    _sort();
  }

  void add(Player player) {
    players.add(player);
    _sort();
  }

  void remove(Player player) => players.removeWhere((p) => p.id == player.id);

  double skill(String skillName) {
    return players
            .map((p) => p.skills[skillName] ?? 5)
            .reduce((a, b) => a + b) /
        players.length;
  }

  Map<String, double> skills(List<String> skillNames) {
    return {for (var s in skillNames) s: skill(s)};
  }

  void _sort() {
    players.sort(
        (p1, p2) => p1.name.toLowerCase().compareTo(p2.name.toLowerCase()));
  }
}

extension StringExtension on String {
  String toTitleCase() {
    if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    } else {
      return this;
    }
  }
}
