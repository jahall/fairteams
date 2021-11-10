import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fairteams/state.dart';
import 'package:fairteams/model.dart';
import 'package:fairteams/group_edit.dart';
import 'package:fairteams/player_edit.dart';
import 'package:fairteams/teams.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool _selectMode = false;
  Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _selectMode = false;
    _selected = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Home'),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editGroup(context),
              tooltip: 'Edit Group'),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () => _newPlayer(context),
                  tooltip: 'New Player')),
        ],
      ),
      body: Column(children: [
        const SizedBox(height: 24),
        (_selectMode) ? _selectedCountInfo(context) : _countInfo(context),
        const SizedBox(height: 12),
        const Divider(thickness: 2),
        const SizedBox(height: 6),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _playerList(context),
            ),
          ),
        ),
      ]),
      floatingActionButton: _actionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _playerList(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 16 * 2;
    List<Widget> fields = widget.group.players
        .map<Widget>((p) => SizedBox(
              width: width,
              height: 40,
              child: Row(children: [
                SizedBox(
                    width: 50,
                    child: (_selectMode)
                        ? Checkbox(
                            value: _selected.contains(p.id),
                            onChanged: (_) {
                              setState(() {
                                if (_selected.contains(p.id)) {
                                  _selected.remove(p.id);
                                } else {
                                  _selected.add(p.id);
                                }
                              });
                            })
                        : p.icon(color: Colors.blue)),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft, child: Text(p.name))),
                p.abilityDisplay(widget.group.skills, color: Colors.blue),
                SizedBox(
                    width: 50,
                    child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => _editPlayer(context, p),
                        tooltip: 'Edit Player')),
              ]),
            ))
        .toList();
    return Column(children: fields + <Widget>[const SizedBox(height: 64)]);
  }

  FloatingActionButton _actionButton(BuildContext context) {
    if (_selectMode) {
      return FloatingActionButton.extended(
        onPressed: (_selected.length > 1) ? () => _chooseTeams(context) : null,
        label: const Text('Choose Teams'),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: (widget.group.players.length > 1)
            ? () => setState(() => _selectMode = true)
            : null,
        label: const Text('New Game'),
      );
    }
  }

  Widget _countInfo(BuildContext context) {
    return Consumer<AppState>(builder: (context, model, child) {
      if (widget.group.players.isEmpty) {
        return Text('You need to add some players!',
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center);
      }
      return RichText(
          text: TextSpan(style: Theme.of(context).textTheme.caption, children: [
        const TextSpan(text: 'You have '),
        TextSpan(
            text: '${widget.group.players.length}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: ' players to choose from'),
      ]));
    });
  }

  Widget _selectedCountInfo(BuildContext context) {
    return RichText(
        text: TextSpan(style: Theme.of(context).textTheme.caption, children: [
      const TextSpan(text: 'Selected '),
      TextSpan(
          text: '${_selected.length}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      const TextSpan(text: ' players'),
    ]));
  }

  void _newPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerEdit(group: widget.group),
      ),
    );
  }

  void _editGroup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupEdit(group: widget.group),
      ),
    );
  }

  void _editPlayer(BuildContext context, Player player) async {
    String? action = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerEdit(group: widget.group, player: player),
      ),
    );

    // If you try to do this on the player_edit page it doesn't work
    // since the navigator pop messes with context and causes a null...
    if (action == 'delete') {
      final snackBar = SnackBar(
        content: Text(
            'Are you sure you want to remove ${player.name} from ${widget.group.name}?'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            Provider.of<AppState>(context, listen: false)
                .addOrUpdatePlayer(widget.group.id, player);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _chooseTeams(BuildContext context) {
    List<Player> players =
        widget.group.players.where((p) => _selected.contains(p.id)).toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ChooseTeams(group: widget.group, players: players),
      ),
    );
  }
}
