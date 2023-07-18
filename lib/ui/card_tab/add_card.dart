import 'package:dumbkey/logic/database_handler.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/card_holder_input.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/card_number.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/cvv_input.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/expiry_input.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/mock_card.dart';
import 'package:dumbkey/ui/shared/title_input.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddCard extends StatefulWidget {
  const AddCard({
    this.savedCard,
    super.key,
  });

  final CardDetails? savedCard;

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  late TextEditingController cardNumberController;
  late TextEditingController cardHolderController;
  late TextEditingController expiryController;
  late TextEditingController cvvController;
  late TextEditingController titleController;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    titleController = TextEditingController();
    cardNumberController = TextEditingController();
    cardHolderController = TextEditingController();
    expiryController = TextEditingController();
    cvvController = TextEditingController();

    if (widget.savedCard != null) {
      titleController.text = widget.savedCard!.title;
      cardNumberController.text = widget.savedCard!.cardNumber;
      cardHolderController.text = widget.savedCard!.cardHolderName;
      expiryController.text = widget.savedCard!.expirationDate;
      cvvController.text = widget.savedCard!.cvv;
    }

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Input'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MockCardWidget(
                cardNumber: cardNumberController,
                cardHolder: cardHolderController,
                expiry: expiryController,
                cvv: cvvController,
              ),
              const SizedBox(height: 16),
              const Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TitleInput(controller: titleController),
              const SizedBox(height: 8),
              CardNumberInput(controller: cardNumberController),
              const SizedBox(height: 8),
              CardHolderInput(controller: cardHolderController),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CVVInput(controller: cvvController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ExpiryInput(controller: expiryController),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (isLoading) return;
                  setState(() => isLoading = true);

                  if (_formKey.currentState!.validate()) {
                    if (widget.savedCard == null) {
                      await addNewCard();
                    } else {
                      await updateCard();
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
    final title = titleController.text;
    final cardNumber = cardNumberController.text;
    final cardHolder = cardHolderController.text;
    final expiry = expiryController.text;
    final cvv = cvvController.text;

    final data = <String, dynamic>{};

    if (widget.savedCard != null) {
      final oldData = widget.savedCard!;
      data[DumbData.title] = oldData.title == title ? null : title;
      data[DumbData.cardNumber] = oldData.cardNumber == cardNumber ? null : cardNumber;
      data[DumbData.cardHolderName] = oldData.cardHolderName == cardHolder ? null : cardHolder;
      data[DumbData.expirationDate] = oldData.expirationDate == expiry ? null : expiry;
      data[DumbData.cvv] = oldData.cvv == cvv ? null : cvv;
    } else {
      data[DumbData.cardHolderName] = cardHolder;
      data[DumbData.cardNumber] = cardNumber;
      data[DumbData.expirationDate] = expiry;
      data[DumbData.cvv] = cvv;
      data[DumbData.title] = title;
    }

    return data;
  }

  Future<void> addNewCard() async {
    final data = retrieveData();

    // required fields
    data[DumbData.id] = idGenerator();
    data[DumbData.dataType] = DataType.card.index.toString();
    data[DumbData.syncStatus] = SyncStatus.synced.index.toString();
    data[DumbData.dateAdded] = DateTime.now().toIso8601String();

    try {
      await GetIt.I.get<DatabaseHandler>().createData(CardDetails.fromMap(data));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add card $e'),
        ),
      );
    }
  }

  Future<void> updateCard() async {
    final updatedData = retrieveData();

    // required fields
    updatedData[DumbData.id] = widget.savedCard!.id;
    updatedData[DumbData.syncStatus] = widget.savedCard!.syncStatus.index.toString();
    updatedData[DumbData.dataType] = null;

    final updatedModel = widget.savedCard!.copyWith(updatedData);
    updatedData.removeWhere((key, value) => value == null || value == '');

    try {
      await GetIt.I.get<DatabaseHandler>().updateData(updatedData, updatedModel);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update card $e'),
        ),
      );
    }
  }
}
