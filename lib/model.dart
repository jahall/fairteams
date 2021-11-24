import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Skill *********************************************************************

class Skill {
  late final String id;
  String name = '';
  double importance = 1.0;

  Skill({id, this.name = '', this.importance = 1.0}) {
    this.id = (id == null) ? const Uuid().v4() : id;
  }

  Skill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    importance = json['importance'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'importance': importance,
      };
}

// Player ********************************************************************

class Player {
  // Class to represent a player
  late final String id;
  String name = '';
  late Map<String, double> abilities;

  Player({id, this.name = '', abilities}) {
    this.id = (id == null) ? const Uuid().v4() : id;
    this.abilities = (abilities == null) ? {} : abilities;
  }

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // Abilities persisted as a list as makes more intuitive sense
    abilities = {
      for (var item in json['abilities']) item['skillId']: item['ability']
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'abilities': abilities.entries
            .map((e) => {'skillId': e.key, 'ability': e.value})
            .toList(),
      };

  double ability(Skill skill) {
    // Player ability for a single skill
    return abilities[skill.id] ?? 5.0;
  }

  double overallAbility(List<Skill> skills) {
    // Aggregate skills to an overall score.
    return skills
            .map((s) => s.importance * ability(s))
            .reduce((a, b) => a + b) /
        skills.map((s) => s.importance).reduce((a, b) => a + b);
  }

  Widget abilityDisplay(List<Skill> skills, {required Color color}) {
    // Pretty traffic light display of skills
    var width = skills.map((s) => s.importance).reduce((a, b) => a + b);
    return SizedBox(
        height: 20,
        width: 10 * width + 2 * (skills.length - 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: skills
              .map((s) => Container(
                  width: 10 * s.importance,
                  height: 20 * ability(s) / 10,
                  color: color.withOpacity(ability(s) / 10)))
              .toList(),
        ));
  }

  Icon icon({Color? color}) {
    if (color != null) {
      return Icon(Icons.person, color: color);
    } else {
      return const Icon(Icons.person);
    }
  }
}

// Team **********************************************************************

class Team {
  String name;
  late List<Player> players;
  Color? color;

  Team({this.name = '', players, this.color}) {
    this.players = (players == null) ? [] : players;
  }

  void add(Player player) => players.add(player);
  void remove(Player player) => players.removeWhere((p) => p.id == player.id);

  double ability(Skill skill, {double? denominator}) {
    // The aggregated skill value for this team.
    if (players.isEmpty) {
      return 0;
    }
    return players.map((p) => p.ability(skill)).reduce((a, b) => a + b) /
        (denominator ?? players.length);
  }

  double overallAbility(List<Skill> skills, {double? denominator}) {
    // The aggregated skill value for this team.
    if (skills.isEmpty | players.isEmpty) {
      return 0;
    }
    return players
            .map((p) => p.overallAbility(skills))
            .reduce((a, b) => a + b) /
        (denominator ?? players.length);
  }

  double diff(Team other, List<Skill> skills) {
    // The difference in skills between this and another team.
    double den =
        max(players.length.toDouble(), other.players.length.toDouble());
    double overallDiff = (overallAbility(skills, denominator: den) -
            other.overallAbility(skills, denominator: den))
        .abs();
    double abilityDiff = skills
        .map((s) =>
            (ability(s, denominator: den) - other.ability(s, denominator: den))
                .abs())
        .reduce((a, b) => a + b);
    return 10 * overallDiff + abilityDiff;
  }

  void sort(List<Skill> skills) {
    // Sort players with the best at the top
    players.sort((p1, p2) =>
        p2.overallAbility(skills).compareTo(p1.overallAbility(skills)));
  }
}

// Group *********************************************************************

class Group {
  // Class representing a group of players of a given sport
  late final String id;
  String name = '';
  String sport = '';
  late List<Skill> skills; // late allows null in constructor
  late Map<String, Player> _players;

  Group({id, this.name = '', this.sport = '', skills, players}) {
    this.id = (id == null) ? const Uuid().v4() : id;
    this.skills = (skills == null) ? [] : skills;
    _players = (players == null) ? {} : {for (var p in players) p.id: p};
  }

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sport = json['sport'];
    skills = json['skills'].map<Skill>((blob) => Skill.fromJson(blob)).toList();
    // Players persisted as a list as makes more intuitive sense
    _players = {
      for (var item in json['players']) item['id']: Player.fromJson(item)
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sport': sport,
        'skills': skills,
        'players': _players.entries.map((e) => e.value).toList(),
      };

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

  Icon icon({Color? color}) {
    IconData? iconData = {
      'basketball': Icons.sports_basketball,
      'charades': Icons.theater_comedy,
      'cricket': Icons.sports_cricket,
      'football': Icons.sports_soccer,
      'hockey': Icons.sports_hockey,
      'netball': Icons.sports_basketball,
      'rugby': Icons.sports_rugby,
      'shinty': Icons.sports_hockey,
      'quiz': Icons.quiz,
      'other': Icons.circle,
    }[sport.toLowerCase()];
    if (color != null) {
      return Icon(iconData, color: color);
    }
    return Icon(iconData);
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
