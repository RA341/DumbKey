import 'package:dumbkey/home/controllers/data_crud_controller.dart';
import 'package:dumbkey/home/ui/shared/title_input.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:flutter/material.dart';

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
  final controller = DataCrudController();

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
    final isUpdate = widget.savedNote != null;

    final titleText = isUpdate ? 'Update Note' : 'Add a new note';
    final submitText = isUpdate ? 'Update' : 'Submit';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TitleInput(controller: _titleController),
              const SizedBox(height: 16),
              TextField(
                controller: _contentsController,
                maxLines: null, // Allow multiple lines for the contents
                decoration: const InputDecoration(
                  labelText: 'Contents',
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: controller.isLoading,
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: value
                        ? () {}
                        : () async {
                            await controller.submitFunction<Notes>(
                              context: context,
                              formKey: _formKey,
                              convertToMapFunc: retrieveData,
                              savedKey: widget.savedNote,
                            );
                          },
                    child: value ? const CircularProgressIndicator() : Text(submitText),
                  );
                },
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
}
