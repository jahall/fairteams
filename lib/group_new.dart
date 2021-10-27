import 'package:flutter/material.dart';

import 'package:fairteams/model.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({Key? key}) : super(key: key);

  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Group _group = Group();
  int _autoValidateModeIndex = AutovalidateMode.disabled.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group'),
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    if (_group.sport == '') {
      _group.sport = 'football';
    }
    const sizedBoxSpace = SizedBox(height: 24);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex],
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              sizedBoxSpace,
              _nameInput(),
              sizedBoxSpace,
              _sportInput(),
              sizedBoxSpace,
              _submitButton(context),
              sizedBoxSpace,
              // Required fields note
              Text(
                '* indicates required field',
                style: Theme.of(context).textTheme.caption,
              ),
              sizedBoxSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameInput() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        filled: true,
        icon: Icon(Icons.group),
        hintText: 'What is the group called?',
        labelText: 'Group Name*',
      ),
      onSaved: (value) {
        _group.name = (value == null) ? '' : value.toString();
      },
      validator: _validateName,
    );
  }

  Widget _sportInput() {
    return DropdownButtonFormField(
      value: _group.sport,
      decoration: InputDecoration(
        filled: true,
        icon: _group.icon(),
        labelText: 'Sport',
      ),
      items: <String>['Basketball', 'Football']
          .map((String value) => DropdownMenuItem(
                value: value.toLowerCase(),
                child: Text(value),
              ))
          .toList(),
      onChanged: (value) {
        setState(() => _group.sport = value.toString());
      },
      onSaved: (value) {
        setState(() => _group.sport = value.toString());
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _handleSubmitted(context),
        child: const Text('Submit'),
      ),
    );
  }

  String? _validateName(String? value) {
    String val = (value == null) ? '' : value.toString();
    if (val.isEmpty) {
      return 'Name required';
    }
    final nameExp = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!nameExp.hasMatch(val)) {
      return 'Alphanumeric characters only';
    }
    return null;
  }

  void _handleSubmitted(BuildContext context) {
    final form = _formKey.currentState;
    final bool isValid = form?.validate() ?? false;
    if (!isValid) {
      _autoValidateModeIndex = AutovalidateMode.always.index;
    } else {
      if (_group.sport == 'football') {
        _group.skillNames = ['Defence', 'Attack', 'Savvy', 'Fitness'];
      }
      form?.save();
      Navigator.of(context).pop(_group);
    }
  }
}
