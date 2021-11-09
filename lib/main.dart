import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/group_edit.dart';
import 'package:fairteams/group_page.dart';
import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const App()));
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

class Home extends StatelessWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: false,
        title: Text(title),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () => _newGroup(context),
                tooltip: 'New Group'),
          )
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<AppState>(
            builder: (context, state, child) => Column(
                children: state.groups
                    .map((group) => ListTile(
                          title: Text(group.name),
                          subtitle: Text(group.subtitle()),
                          leading: group.icon(color: Colors.blue),
                          trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () => _removeGroup(context, group),
                              tooltip: 'Delete Group'),
                          onTap: () => _showGroup(context, group),
                        ))
                    .toList()),
          ),
        ),
      ),
    );
  }

  void _newGroup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GroupEdit(),
      ),
    );
  }

  void _showGroup(BuildContext context, Group group) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Consumer<AppState>(
            builder: (_, state, __) => GroupPage(
                  group: state.group(group.id),
                )),
      ),
    );
  }

  void _removeGroup(BuildContext context, Group group) {
    final snackBar = SnackBar(
      content: Text('Are you sure you want to delete ${group.name}?'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          Provider.of<AppState>(context, listen: false).addOrUpdateGroup(group);
        },
      ),
    );

    Provider.of<AppState>(context, listen: false).removeGroup(group.id);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
