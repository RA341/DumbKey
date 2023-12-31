import 'package:dumbkey/home/controllers/data_crud_controller.dart';
import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/form/card_holder_input.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/form/card_number.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/form/cvv_input.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/form/expiry_input.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/form/mock_card.dart';
import 'package:dumbkey/home/ui/shared/title_input.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

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
  final controller = DataCrudController();
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
    final isUpdate = widget.savedCard != null;

    final titleText = isUpdate ? 'Update Card' : 'Add a new card';
    final submitText = isUpdate ? 'Update' : 'Submit';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
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
              ValueListenableBuilder(
                valueListenable: controller.isLoading,
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: value
                        ? () {}
                        : () async {
                            await controller.submitFunction<CardDetails>(
                              context: context,
                              formKey: _formKey,
                              convertToMapFunc: retrieveData,
                              savedKey: widget.savedCard,
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
    final data = retrieveData()
      ..addAll(TypeBase.defaultMap(DataType.card)); // adds default required values for typebase

    try {
      await dep.get<DatabaseHandler>().createData(CardDetails.fromMap(data));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add card $e'),
        ),
      );
    }
  }

  Future<void> updateCard() async {
    final updateData = retrieveData()..addAll(widget.savedCard!.defaultUpdateMap());

    final updatedModel = widget.savedCard!.copyWithFromMap(updateData);
    updateData.removeWhere((key, value) => value == null || value == '');

    try {
      await dep.get<DatabaseHandler>().updateData(updateData, updatedModel);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update card $e'),
        ),
      );
    }
  }
}
