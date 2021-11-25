import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/group_edit.dart';
import 'package:fairteams/group_page.dart';
import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';
import 'package:fairteams/utils.dart';

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
            padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
            child: IconButton(
                icon: const Icon(Icons.rotate_left),
                onPressed: () => _revertToExample(context),
                tooltip: 'Revert to Example'),
          )
        ],
      ),
      body: Box(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<AppState>(
            builder: (context, state, child) => Column(
                children: state.groups
                    .map((group) => ListTile(
                          title: Text(group.name),
                          subtitle: Text(group.subtitle()),
                          leading: group.icon(color: primaryColor(context)),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeGroup(context, group),
                              tooltip: 'Delete Group'),
                          onTap: () => _showGroup(context, group),
                        ))
                    .toList()),
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newGroup(context),
        tooltip: 'New Group',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                  key: Key(group.id),
                  group: state.group(group.id),
                )),
      ),
    );
  }

  void _revertToExample(BuildContext context) {
    Provider.of<AppState>(context, listen: false).revertToExample();
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
