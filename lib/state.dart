import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/group_example.dart';

class AppState extends ChangeNotifier {
  final String version = '1';
  late Map<String, Group> _groups;

  AppState({Key? key}) {
    _groups = {};
    _load();
  }

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
    _save();
  }

  void removeGroup(String id) {
    _groups.remove(id);
    notifyListeners();
    _save();
  }

  void addOrUpdatePlayer(String groupId, Player player) {
    _groups[groupId]!.addOrUpdatePlayer(player);
    notifyListeners();
    _save();
  }

  void removePlayer(String groupId, String playerId) {
    _groups[groupId]!.removePlayer(playerId);
    notifyListeners();
    _save();
  }

  void revertToExample() {
    _groups = loadSampleGroups();
    notifyListeners();
    _save();
  }

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    String blob = prefs.getString('state') ?? '';
    try {
      var json = jsonDecode(blob);
      _groups = {
        for (var item in json['groups']) item['id']: Group.fromJson(item)
      };
    } catch (error) {
      print('Failed to load state ${error.toString()}');
      prefs.remove('state');
      _groups = loadSampleGroups();
    }
    notifyListeners();
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    List<Group> groups = _groups.entries.map((e) => e.value).toList();
    Map<String, dynamic> json = {'version': version, 'groups': groups};
    prefs.setString('state', jsonEncode(json));
  }
}
