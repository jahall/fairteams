import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/group_example.dart';

class AppState extends ChangeNotifier {
  final Map<String, Group> _groups = loadSampleGroups();

  Group group(String groupId) => _groups[groupId]!;

  UnmodifiableListView<Group> get groups {
    // List of groups sorted by name
    List<Group> groupsList = _groups.entries.map((e) => e.value).toList();
    groupsList.sort(
        (g1, g2) => g1.name.toLowerCase().compareTo(g2.name.toLowerCase()));
    return UnmodifiableListView(groupsList);
  }

  void addOrUpdateGroup(Group group) {
    _groups[group.id] = group;
    notifyListeners();
  }

  void removeGroup(String id) {
    _groups.remove(id);
    notifyListeners();
  }

  void addOrUpdatePlayer(String groupId, Player player) {
    _groups[groupId]!.addOrUpdatePlayer(player);
    notifyListeners();
  }

  void removePlayer(String groupId, String playerId) {
    _groups[groupId]!.removePlayer(playerId);
    notifyListeners();
  }
}
