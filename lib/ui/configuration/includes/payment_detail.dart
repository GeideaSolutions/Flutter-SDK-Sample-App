import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';
import 'package:test_app/ui/configuration/includes/drop_down.dart';

class PaymentDetail extends StatelessWidget {
  final _verticalSizeBox = const SizedBox(height: 20.0);

  final String savedPaymentOperation;

  final List<String> paymentOperations;

  final TextEditingController currencyController;
  final TextEditingController callbackUrlController;
  final TextEditingController merchantReferenceIdController;
  final Map<String, bool> paymentOptions;
  final Function(String key, bool? value) onCheckChange;

  const PaymentDetail({
    super.key,
    required this.savedPaymentOperation,
    required this.paymentOperations,
    required this.currencyController,
    required this.callbackUrlController,
    required this.merchantReferenceIdController,
    required this.paymentOptions,
    required this.onCheckChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _verticalSizeBox,
        Text(
          "Payment Details",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _verticalSizeBox,
        TextFormField(
          controller: currencyController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Currency *",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        Text(
          "Endpoints",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _verticalSizeBox,
        TextFormField(
          controller: callbackUrlController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Callback URL",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        Text(
          "Payment options",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: Text(
                  "Show Email",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                value: paymentOptions["show_email"],
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? value) {
                  onCheckChange("show_email", value);
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: Text(
                  "Show Address",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                value: paymentOptions["show_address"],
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? value) {
                  onCheckChange("show_address", value);
                },
              ),
            ),
          ],
        ),
        _verticalSizeBox,
        TextFormField(
          controller: merchantReferenceIdController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Merchant Reference ID",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        MyDropDown(
            hint: "Payment Operation",
            initialValue: savedPaymentOperation,
            items: paymentOperations,
            keyPref: keyPaymentOperation),
      ],
    );
  }
}
