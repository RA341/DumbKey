import 'package:dumbkey/ui/card_tab/widgets/form_widgets/card_holder_input.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/card_number.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/cvv_input.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/expiry_input.dart';
import 'package:dumbkey/ui/card_tab/widgets/form_widgets/mock_card.dart';
import 'package:flutter/material.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  late TextEditingController cardNumberController;
  late TextEditingController cardHolderController;
  late TextEditingController expiryController;
  late TextEditingController cvvController;

  @override
  void initState() {
    super.initState();
    cardNumberController = TextEditingController();
    cardHolderController = TextEditingController();
    expiryController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  void dispose() {
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
              onPressed: () {
                // TODO: Implement button press functionality
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
