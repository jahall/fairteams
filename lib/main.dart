import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';
import 'package:fairteams/group_new.dart';
import 'package:fairteams/group_page.dart';
import 'package:fairteams/group_example.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fair Teams',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: 'Fair Teams'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _groups = loadSampleGroups();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: false,
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(Icons.group_add),
              onPressed: () => _newGroup(context),
              tooltip: 'New Group'),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
              children: _groups
                  .map((group) => ListTile(
                        title: Text(group.name),
                        subtitle: Text(group.subtitle()),
                        leading: group.icon(),
                        onTap: () => _showGroup(context, group),
                      ))
                  .toList()),
        ),
      ),
    );
  }

  void _newGroup(BuildContext context) async {
    final Group? group = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewGroup(),
      ),
    );
    if (group != null) {
      setState(() => _groups.add(group));
    }
  }

  void _showGroup(BuildContext context, Group group) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GroupPage(
            group: group,
            addPlayer: _addPlayer,
            replacePlayer: _replacePlayer,
            removePlayer: _removePlayer),
      ),
    );
  }

  void _addPlayer(Group group, Player player) {
    setState(() {
      group.players.add(player);
      group.players.sort(
          (p1, p2) => p1.name.toLowerCase().compareTo(p2.name.toLowerCase()));
    });
  }

  void _replacePlayer(Group group, Player player, int index) {
    setState(() {
      group.players[index] = player;
      group.players.sort(
          (p1, p2) => p1.name.toLowerCase().compareTo(p2.name.toLowerCase()));
    });
  }

  void _removePlayer(Group group, int index) {
    setState(() => group.players.removeAt(index));
  }
}
