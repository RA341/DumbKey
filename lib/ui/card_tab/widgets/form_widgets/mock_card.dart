import 'package:flutter/material.dart';

class MockCardWidget extends StatefulWidget {
  const MockCardWidget({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiry,
    required this.cvv,
    super.key,
  });

  final TextEditingController cardNumber;
  final TextEditingController cardHolder;
  final TextEditingController expiry;
  final TextEditingController cvv;

  @override
  State<MockCardWidget> createState() => _MockCardWidgetState();
}

class _MockCardWidgetState extends State<MockCardWidget> {
  late String _cardNumber;
  late String _cardHolder;
  late String _expiry;
  late String _cvv;

  @override
  void initState() {
    _expiry = widget.expiry.text;
    _cardHolder = widget.cardHolder.text;
    _cardNumber = widget.cardNumber.text;
    _cvv = widget.cvv.text;

    widget.cardNumber.addListener(() {
      setState(() {
        _cardNumber = widget.cardNumber.text;
      });
    });

    widget.cardHolder.addListener(() {
      setState(() {
        _cardHolder = widget.cardHolder.text;
      });
    });

    widget.expiry.addListener(() {
      setState(() {
        _expiry = widget.expiry.text;
      });
    });

    widget.cvv.addListener(() {
      setState(() {
        _cvv = widget.cvv.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _cardNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Card Holder'),
                Text('Expires'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_cardHolder),
                Text(_expiry),
              ],
            ),
          ],
        ),
      ),
    );
  }
}