import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardDetailsPage extends StatelessWidget {
  const CardDetailsPage({required this.card, super.key});

  final CardDetails card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardDetailField(
              label: 'Card Number',
              value: card.cardNumber,
            ),
            const SizedBox(height: 16),
            CardDetailField(
              label: 'Card Holder',
              value: card.cardHolderName,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CardDetailField(
                    label: 'Expiry',
                    value: card.expirationDate,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CardDetailField(
                    label: 'CVV',
                    value: card.cvv, // Replace with CVV
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetailField extends StatelessWidget {
  const CardDetailField({required this.label, required this.value, super.key});

  final String label;
  final String value;

  void _copyToClipboard(String value, BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () => _copyToClipboard(value, context),
                icon: const Icon(Icons.content_copy),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
