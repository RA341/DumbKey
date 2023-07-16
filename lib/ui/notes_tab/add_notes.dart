import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
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
      data[DumbData.title] = widget.savedNote!.title == title ? null : title;
      data[DumbData.notes] = widget.savedNote!.notes == contents ? null : contents;
    } else {
      data[DumbData.title] = title;
      data[DumbData.notes] = contents;
    }

    return data;
  }

  Future<void> _createNote() async {
    final data = retrieveData();
    data[DumbData.id] = idGenerator();
    data[DumbData.dataType] = DataType.notes.index.toString();
    data[DumbData.syncStatus] = SyncStatus.synced.index.toString();
    data[DumbData.dateAdded] = DateTime.now().toIso8601String();

    final newPasskey = Notes.fromMap(data);

    try {
      await GetIt.I<DatabaseHandler>().createData(newPasskey);
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
    updateData[DumbData.id] = widget.savedNote!.id;
    updateData[DumbData.dataType] = null;
    updateData[DumbData.syncStatus] = null;
    updateData[DumbData.dateAdded] = null;

    final updatedNote = widget.savedNote!.copyWith(updateData);

    updateData.removeWhere((key, value) => value == null || value == '');

    try {
      await GetIt.I<DatabaseHandler>().updateData(updateData, updatedNote);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update $e'),
        ),
      );
    }
  }
}
