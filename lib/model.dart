import 'package:flutter/material.dart';

extension StringExtension on String {
  String toTitleCase() {
    if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    } else {
      return this;
    }
  }
}

class Group {
  String name;
  String sport;
  late List<String> skillNames; // late allows null in constructor
  late List<Player> players;

  Group({this.name = '', this.sport = '', skillNames, players}) {
    this.skillNames = (skillNames == null) ? [] : skillNames;
    this.players = (players == null) ? [] : players;
  }

  String subtitle() {
    return sport.toTitleCase() + ': ' + players.length.toString() + ' players';
  }

  Icon icon() {
    IconData? iconData = {
      'basketball': Icons.sports_basketball,
      'football': Icons.sports_soccer,
    }[sport];
    return Icon(iconData);
  }
}

class Player {
  String name;
  late Map<String, double> skills;

  Player({this.name = '', skills}) {
    this.skills = (skills == null) ? {} : skills;
  }

  Icon icon({Color? color}) {
    if (color != null) {
      return Icon(Icons.person, color: color);
    } else {
      return const Icon(Icons.person);
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

class Team {
  String name;
  Color? color;
  late List<Player> players;

  Team({this.name = '', this.color, players}) {
    this.players = (players == null) ? [] : players;
  }

  Map<String, double> skills(List<String> skillNames) {
    return {
      for (var s in skillNames)
        s: players.map((p) => p.skills[s] ?? 5).reduce((a, b) => a + b) /
            players.length
    };
  }
}
