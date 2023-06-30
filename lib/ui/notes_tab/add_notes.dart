import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key, this.savedNote});

  final Notes? savedNote;

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  late TextEditingController _titleController;
  late TextEditingController _contentsController;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentsController = TextEditingController();

    if (widget.savedNote != null) {
      _titleController.text = widget.savedNote!.title;
      _contentsController.text = widget.savedNote!.notes;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentsController,
                maxLines: null, // Allow multiple lines for the contents
                decoration: const InputDecoration(
                  labelText: 'Contents',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (isLoading) return;
                  setState(() => isLoading = true);

                  if (_formKey.currentState!.validate()) {
                    if (widget.savedNote != null) {
                      await _updateNote();
                    } else {
                      await _createNote();
                    }
                  }

                  setState(() => isLoading = false);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: isLoading ? const CircularProgressIndicator() : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> retrieveData() {
    final title = _titleController.text;
    final contents = _contentsController.text;

    final data = <String, dynamic>{};

    if (widget.savedNote != null) {
      data[KeyNames.title] = widget.savedNote!.title == title ? null : title;
      data[KeyNames.notes] = widget.savedNote!.notes == contents ? null : contents;
    } else {
      data[KeyNames.title] = title;
      data[KeyNames.notes] = contents;
    }

    return data;
  }

  Future<void> _createNote() async {
    final data = retrieveData();
    data[KeyNames.id] = idGenerator();
    data[KeyNames.dataType] = DataType.notes.index.toString();
    data[KeyNames.syncStatus] = SyncStatus.synced.index.toString();
    data[KeyNames.dateAdded] = DateTime.now().toIso8601String();

    final newPasskey = Notes.fromMap(data);

    try {
      await GetIt.I<DatabaseHandler>().createPassKey(newPasskey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add $e'),
        ),
      );
    }
  }

  Future<void> _updateNote() async {
    final updateData = retrieveData();
    updateData[KeyNames.id] = widget.savedNote!.id;
    updateData[KeyNames.dataType] = null;
    updateData[KeyNames.syncStatus] = null;
    updateData[KeyNames.dateAdded] = null;

    final updatedNote = widget.savedNote!.copyWith(updateData);

    updateData.removeWhere((key, value) => value == null || value == '');

    try {
      await GetIt.I<DatabaseHandler>().updatePassKey(updateData, updatedNote);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update $e'),
        ),
      );
    }
  }
}
