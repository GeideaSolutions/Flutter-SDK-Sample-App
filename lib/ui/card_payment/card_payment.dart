import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geideapay/geideapay.dart';
import 'package:intl/intl.dart';
import '../../storage/app_preference.dart';
import 'input_card_view.dart';
import '../../utils/HexColor.dart';
import '../../config/globals.dart' as globals;

enum PaymentType { geidea, merchant }

class CardPayment extends StatefulWidget {
  const CardPayment({super.key});

  @override
  CardPaymentState createState() => CardPaymentState();
}

class CardPaymentState extends State<CardPayment> {
  final _plugin = GeideapayPlugin();

  PaymentType? _character = PaymentType.geidea;

  String _currency = "";

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _checkoutInProgress = false;

  String _callbackUrl = "https://returnurl.com";
  String _returnUrl = "https://returnurl.com";

  String? _orderId, _sessionId;

  String? _threeDSecureId;

  PaymentCard? card;

  OrderApiResponse? orderApiResponse;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() async {
    _plugin.initialize(
        publicKey: globals.keyMerchantKey ?? "",
        apiPassword: globals.keyMerchantPass ?? "",
        baseUrl: globals.keyBaseUrl ?? "");

    _currency = await keyCurrency.getPrefData() ?? "";
    _callbackUrl = await keyCallbackUrl.getPrefData() ?? _callbackUrl;
    _returnUrl = await keyReturnUrl.getPrefData() ?? _returnUrl;

    _amountController.text =
        await keyAmount.getPrefData() ?? await "100".addPrefData(keyAmount);
    _cardNumberController.text = await keyCardNumber.getPrefData() ?? "";
    _monthController.text = await keyCardExpMonth.getPrefData() ?? "";
    _yearController.text = await keyCardExpYear.getPrefData() ?? "";
    _cvvController.text = await keyCardCVV.getPrefData() ?? "";
    _cardHolderController.text = await keyCardHolderName.getPrefData() ?? "";

    if (await keyPaymentType.getPrefData() == "PaymentType.merchant") {
      _character = PaymentType.merchant;
    }

    setState(() {});

    _initListener();
  }

  void _initListener() {
    _amountController.addListener(() async {
      _amountController.text.toString().addPrefData(keyAmount);
    });
    _cardNumberController.addListener(() {
      _cardNumberController.text.toString().addPrefData(keyCardNumber);
    });
    _monthController.addListener(() {
      _monthController.text.toString().addPrefData(keyCardExpMonth);
    });
    _yearController.addListener(() {
      _yearController.text.toString().addPrefData(keyCardExpYear);
    });
    _cvvController.addListener(() {
      _cvvController.text.toString().addPrefData(keyCardCVV);
    });
    _cardHolderController.addListener(() {
      _cardHolderController.text.toString().addPrefData(keyCardHolderName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Payment"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      border: OutlineInputBorder(),
                                      labelText: "Amount *"),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                _currency,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            title: const Text("Geidea SDK"),
                            leading: Radio(
                                value: PaymentType.geidea,
                                groupValue: _character,
                                onChanged: (PaymentType? value) {
                                  setState(() {
                                    _character = value;
                                    value.addPrefData(keyPaymentType);
                                  });
                                }),
                            contentPadding: const EdgeInsets.only(left: -100),
                            onTap: () {
                              setState(() {
                                _character = PaymentType.geidea;
                                PaymentType.geidea.addPrefData(keyPaymentType);
                              });
                            },
                          ),
                          ListTile(
                            title: const Text("Merchant PCI-DSS"),
                            leading: Radio(
                                value: PaymentType.merchant,
                                groupValue: _character,
                                onChanged: (PaymentType? value) {
                                  setState(() {
                                    _character = value;
                                    value.addPrefData(keyPaymentType);
                                  });
                                }),
                            contentPadding: const EdgeInsets.all(0),
                            onTap: () {
                              setState(() {
                                _character = PaymentType.merchant;
                                PaymentType.merchant
                                    .addPrefData(keyPaymentType);
                              });
                            },
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: (_character == PaymentType.merchant)
                                ? InputCardView(
                                    cardNumberController: _cardNumberController,
                                    monthController: _monthController,
                                    yearController: _yearController,
                                    cvvController: _cvvController,
                                    cardHolderController: _cardHolderController,
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    return Column(children: [
                      if (_character == PaymentType.geidea)
                        ElevatedButton(
                          onPressed: () => _payNow(context),
                          child: const Center(
                            child: Text("PAY"),
                          ),
                        ),
                      if (_character == PaymentType.merchant)
                        _getPlatformButton('Create Session',
                            () => _handleCreateSession(context), true),
                      if (_character == PaymentType.merchant)
                        _getPlatformButton('initiate authentication',
                            () => _handleInitAuth(context), _sessionId != null),
                      if (_character == PaymentType.merchant)
                        _getPlatformButton('Payer authentication',
                            () => _handlePayerAuth(context), _orderId != null),
                      if (_character == PaymentType.merchant)
                        _getPlatformButton(
                            'Pay with card',
                            () => _handlePayCard(context),
                            _orderId != null && _threeDSecureId != null),
                      if (_character == PaymentType.merchant)
                        _getPlatformButton(
                            'Refund',
                            () => _handleRefund(context),
                            orderApiResponse != null && _orderId != null),
                    ]);
                  }),
                ],
              ),
              _checkoutInProgress
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  _payNow(BuildContext context) async {
    FocusScope.of(context).unfocus();
    Address billingAddress = Address(
        city: await keyBillingCity.getPrefData(),
        countryCode: await keyBillingCountryCode.getPrefData(),
        street: await keyBillingStreet.getPrefData(),
        postCode: await keyBillingPostalCode.getPrefData());
    Address shippingAddress = Address(
        city: await keyShippingCity.getPrefData(),
        countryCode: await keyShippingCountryCode.getPrefData(),
        street: await keyShippingStreet.getPrefData(),
        postCode: await keyShippingPostalCode.getPrefData());

    CheckoutOptions checkoutOptions = CheckoutOptions(
      double.parse((await keyAmount.getPrefData()).toString()),
      (await keyCurrency.getPrefData()).toString(),
      callbackUrl: await keyCallbackUrl.getPrefData() ?? "",
      returnUrl: await keyReturnUrl.getPrefData() ?? "",
      lang: (await keySdkLanguage.getPrefData() ?? "AR").toLowerCase(),
      billingAddress: billingAddress,
      shippingAddress: shippingAddress,
      customerEmail: await keyCustomerEmail.getPrefData(),
      merchantReferenceID: await keyMerchantRefId.getPrefData(),
      paymentIntentId: null,
      paymentOperation: await keyPaymentOperation.getPrefData(),
      showAddress: await keyShowAddress.getPrefData() == "true",
      showEmail: await keyShowEmail.getPrefData() == "true",
      textColor:
          HexColor.fromHex(await keyColorText.getPrefData() ?? "#ffffff"),
      cardColor:
          HexColor.fromHex(await keyColorCard.getPrefData() ?? "#ff4d00"),
      payButtonColor:
          HexColor.fromHex(await keyColorPayButton.getPrefData() ?? "#ff4d00"),
      cancelButtonColor: HexColor.fromHex(
          await keyColorCancelButton.getPrefData() ?? "#878787"),
      backgroundColor:
          HexColor.fromHex(await keyColorBG.getPrefData() ?? "#2c2222"),
    );

    setState(() => _checkoutInProgress = true);

    try {
      OrderApiResponse response = await _plugin.checkout(
          context: context, checkoutOptions: checkoutOptions);
      debugPrint('Response = $response');

      setState(() => _checkoutInProgress = false);

      _updateStatus(
          response.detailedResponseMessage, truncate(response.toString()));
    } catch (e) {
      debugPrint("PayNow: $e");
      setState(() => _checkoutInProgress = false);
      _showMessage(e.toString());
    }
  }

  _handleCreateSession(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _checkoutInProgress = true);
      _formKey.currentState?.save();

      String timeStamp =
          DateFormat('MM/dd/yyyy hh:mm:ss a').format(DateTime.now());

      DirectSessionRequestBody directSessionRequestBody =
          DirectSessionRequestBody(
        double.parse(_amountController.text),
        _currency,
        timeStamp,
        (await keyMerchantRefId.getPrefData()).toString(),
        Utils.generateSignature(
            globals.keyMerchantKey ?? "",
            double.parse(_amountController.text),
            _currency,
            (await keyMerchantRefId.getPrefData()).toString(),
            globals.keyMerchantPass ?? "",
            timeStamp),
        callbackUrl: _callbackUrl,
        paymentIntentId: null,
        paymentOperation: await keyPaymentOperation.getPrefData(),
        language: (await keySdkLanguage.getPrefData() ?? "AR").toLowerCase(),
        appearance: Appearance(
          showEmail: await keyShowEmail.getPrefData() == "true",
          showAddress: await keyShowAddress.getPrefData() == "true",
        ),
      );

      try {
        DirectSessionApiResponse response = await _plugin.createSession(
            directSessionRequestBody: directSessionRequestBody);
        debugPrint('Response = $response');
        setState(() => _checkoutInProgress = false);
        _sessionId = response.session?.id;
        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));
      } catch (e) {
        setState(() => _checkoutInProgress = false);
        _showMessage("Check console for error");
        rethrow;
      }
    }
  }

  _handleInitAuth(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _checkoutInProgress = true);
      _formKey.currentState?.save();

      card = _getCardFromUI();

      InitiateAuthenticationRequestBody initiateAuthenticationRequestBody =
          InitiateAuthenticationRequestBody(
              _sessionId, card?.number, _returnUrl,
              amount: double.parse(_amountController.text),
              currency: _currency,
              callbackUrl: _callbackUrl,
              cardOnFile: false);
      try {
        AuthenticationApiResponse response =
            await _plugin.initiateAuthentication(
                initiateAuthenticationRequestBody:
                    initiateAuthenticationRequestBody);
        debugPrint('Response = $response');
        setState(() => _checkoutInProgress = false);
        _orderId = response.orderId;
        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));
      } catch (e) {
        setState(() => _checkoutInProgress = false);
        _showMessage("Check console for error");
        rethrow;
      }
    }
  }

  _handlePayerAuth(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _checkoutInProgress = true);
      _formKey.currentState?.save();

      PayerAuthenticationRequestBody payerAuthenticationRequestBody =
          PayerAuthenticationRequestBody(
              _sessionId,
              _orderId,
              card,
              DeviceIdentification(
                language:
                    (await keySdkLanguage.getPrefData() ?? "AR").toLowerCase(),
              ),
              -120,
              ReturnUrl: _returnUrl,
              callbackUrl: _callbackUrl,
              cardOnFile: false);

      try {
        AuthenticationApiResponse response = await _plugin.payerAuthentication(
            payerAuthenticationRequestBody: payerAuthenticationRequestBody,
            context: context);
        debugPrint('Response = $response');
        setState(() => _checkoutInProgress = false);

        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));

        _orderId = response.orderId;
        _threeDSecureId = response.threeDSecureId;
      } catch (e) {
        setState(() => _checkoutInProgress = false);
        _showMessage("Check console for error");
        rethrow;
      }
    }
  }

  _handlePayCard(BuildContext context) async {
    setState(() => _checkoutInProgress = true);
    _formKey.currentState?.save();

    PayDirectRequestBody payDirectRequestBody = PayDirectRequestBody(
      _sessionId,
      _orderId,
      _threeDSecureId,
      card,
      returnUrl: _returnUrl,
    );

    try {
      orderApiResponse =
          await _plugin.directPay(payDirectRequestBody: payDirectRequestBody);
      debugPrint('Response = $orderApiResponse');
      setState(() => _checkoutInProgress = false);

      _updateStatus(orderApiResponse!.detailedResponseMessage,
          truncate(orderApiResponse!.toString()));
    } catch (e) {
      setState(() => _checkoutInProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  _handleRefund(BuildContext context) async {
    setState(() => _checkoutInProgress = true);
    _formKey.currentState?.save();

    RefundRequestBody refundRequestBody = RefundRequestBody(_orderId!);

    try {
      OrderApiResponse response =
          await _plugin.refund(refundRequestBody: refundRequestBody);
      debugPrint('Response = $response');
      setState(() => _checkoutInProgress = false);

      _updateStatus(
          response.detailedResponseMessage, truncate(response.toString()));
    } catch (e) {
      setState(() => _checkoutInProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumberController.text,
      name: _cardHolderController.text,
      cvc: _cvvController.text,
      expiryMonth: int.parse(_monthController.text.toString()),
      expiryYear: int.parse(_yearController.text.toString()),
    );
  }

  Widget _getPlatformButton(String string, Function() function, bool active) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color:
            active ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
        child: Center(
          child: Text(
            string,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      widget = ElevatedButton(
        onPressed: active ? function : null,
        style: ButtonStyle(
            backgroundColor:
                active ? MaterialStateProperty.all(Colors.lightBlue) : null),
        child: Center(
          child: Text(
            string.toUpperCase(),
            style: const TextStyle(fontSize: 17.0),
          ),
        ),
      );
    }
    return widget;
  }

  String truncate(String text, {length = 200, omission = '...'}) {
    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  _updateStatus(String? reference, String? message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
}
