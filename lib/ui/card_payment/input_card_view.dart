import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var maskFormatterCardNumber = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var maskFormatterMonth = MaskTextInputFormatter(
    mask: '01',
    filter: {"0": RegExp(r'[0-1]'), "1": RegExp(r'[1-9]')},
    type: MaskAutoCompletionType.lazy);

class InputCardView extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final TextEditingController cvvController;
  final TextEditingController cardHolderController;

  const InputCardView({
    super.key,
    required this.cardNumberController,
    required this.monthController,
    required this.yearController,
    required this.cvvController,
    required this.cardHolderController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: cardNumberController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: <TextInputFormatter>[maskFormatterCardNumber],
          decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(),
              labelText: "Card Number *"),
          validator: validateNumber('card number'),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: monthController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: <TextInputFormatter>[maskFormatterMonth],
                maxLength: 2,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: "Exp. month *",
                  counterText: "",
                ),
                validator: validateNumber('expiry month'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: yearController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 4,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: "Exp. year *",
                  counterText: "",
                ),
                validator: validateNumber('expiry year'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 4,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: "CVV *",
                  counterText: "",
                ),
                validator: validateNumber('cvv'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: cardHolderController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[a-z A-Z]')),
          ],
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Card holder *",
            counterText: "",
          ),
          validator: validateNumber('card holder name'),
        ),
      ],
    );
  }

  validateNumber(String s) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter ' + s;
      }
      return null;
    };
  }
}
