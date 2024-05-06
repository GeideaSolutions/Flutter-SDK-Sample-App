import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:geideapay/geideapay.dart' as gp;
import 'package:test_app/ui/configuration/includes/drop_down.dart';
import '../../storage/app_preference.dart';
import 'includes/address.dart';
import 'includes/payment_detail.dart';
import 'includes/tab_selector.dart';
import 'package:test_app/utils/HexColor.dart';
import '../../config/globals.dart' as globals;

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  ConfigurationState createState() => ConfigurationState();
}

class ConfigurationState extends State<Configuration> {
  final _verticalSizeBox = const SizedBox(height: 20.0);

  String _language = "Arabic";

  Map<String, bool> _paymentOptions = {
    "show_email": false,
    "show_address": false,
  };

  final List<String> _paymentOperations = [
    'Default (merchant configuration)',
    'Pay',
    'PreAuthorize',
    'AuthorizeCapture'
  ];

  final List<gp.ServerEnvironmentModel> _baseUrlType =
      gp.ServerEnvironment.environments();

  final TextEditingController _merchantKeyController = TextEditingController();
  final TextEditingController _merchantPasswordController =
      TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _callbackUrlController = TextEditingController();
  final TextEditingController _returnUrlController = TextEditingController();
  final TextEditingController _merchantReferenceIdController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();

  final TextEditingController _billingCity = TextEditingController();
  final TextEditingController _billingStreet = TextEditingController();
  final TextEditingController _billingCountryCode = TextEditingController();
  final TextEditingController _billingPostalCode = TextEditingController();

  final TextEditingController _shippingCity = TextEditingController();
  final TextEditingController _shippingStreet = TextEditingController();
  final TextEditingController _shippingCountryCode = TextEditingController();
  final TextEditingController _shippingPostalCode = TextEditingController();

  String _savedPaymentOperation = "Default (merchant configuration)";

  bool _shippingSameAsBilling = false;

  Color _colorText = const Color(0xffffffff);
  Color _colorCard = const Color(0xffff4d00);
  Color _colorPayButton = const Color(0xffff4d00);
  Color _colorCancelButton = const Color(0xff878787);
  Color _colorBG = const Color(0xff2c2222);

  @override
  void initState() {
    super.initState();

    /*WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => loadBody = true));*/
    _setData();
  }

  void _setData() async {
    _language = (await keySdkLanguage.getPrefData() ?? "AR") == "EN"
        ? "English"
        : _language;
    _savedPaymentOperation =
        await keyPaymentOperation.getPrefData() ?? _paymentOperations[1];

    _paymentOptions = {
      "show_email": (await keyShowEmail.getPrefData() == "true"),
      "show_address": (await keyShowAddress.getPrefData() == "true"),
    };

    _merchantKeyController.text = globals.keyMerchantKey ?? "";
    _merchantPasswordController.text = globals.keyMerchantPass ?? "";
    _currencyController.text = await keyCurrency.getPrefData() ?? "";
    _callbackUrlController.text = await keyCallbackUrl.getPrefData() ?? "";
    _returnUrlController.text = await keyReturnUrl.getPrefData() ?? "";
    _merchantReferenceIdController.text =
        await keyMerchantRefId.getPrefData() ?? "";
    _customerEmailController.text = await keyCustomerEmail.getPrefData() ?? "";

    _billingCity.text = await keyBillingCity.getPrefData() ?? "";
    _billingStreet.text = await keyBillingStreet.getPrefData() ?? "";
    _billingCountryCode.text = await keyBillingCountryCode.getPrefData() ?? "";
    _billingPostalCode.text = await keyBillingPostalCode.getPrefData() ?? "";

    _shippingCity.text = await keyShippingCity.getPrefData() ?? "";
    _shippingStreet.text = await keyShippingStreet.getPrefData() ?? "";
    _shippingCountryCode.text =
        await keyShippingCountryCode.getPrefData() ?? "";
    _shippingPostalCode.text = await keyShippingPostalCode.getPrefData() ?? "";

    _colorText =
        HexColor.fromHex(await keyColorText.getPrefData() ?? _colorText.hex);
    _colorCard =
        HexColor.fromHex(await keyColorCard.getPrefData() ?? _colorCard.hex);
    _colorPayButton = HexColor.fromHex(
        await keyColorPayButton.getPrefData() ?? _colorPayButton.hex);
    _colorCancelButton = HexColor.fromHex(
        await keyColorCancelButton.getPrefData() ?? _colorCancelButton.hex);
    _colorBG = HexColor.fromHex(await keyColorBG.getPrefData() ?? _colorBG.hex);

    setState(() {});
  }

  void _saveData() {
    _currencyController.text.toString().addPrefData(keyCurrency);
    _callbackUrlController.text.toString().addPrefData(keyCallbackUrl);
    _returnUrlController.text.toString().addPrefData(keyReturnUrl);
    _merchantReferenceIdController.text
        .toString()
        .addPrefData(keyMerchantRefId);

    _customerEmailController.text.toString().addPrefData(keyCustomerEmail);

    _billingCity.text.toString().addPrefData(keyBillingCity);
    _billingStreet.text.toString().addPrefData(keyBillingStreet);
    _billingCountryCode.text.toString().addPrefData(keyBillingCountryCode);
    _billingPostalCode.text.toString().addPrefData(keyBillingPostalCode);

    _shippingCity.text.toString().addPrefData(keyShippingCity);
    _shippingStreet.text.toString().addPrefData(keyShippingStreet);
    _shippingCountryCode.text.toString().addPrefData(keyShippingCountryCode);
    _shippingPostalCode.text.toString().addPrefData(keyShippingPostalCode);

    _paymentOptions['show_email'].addPrefData(keyShowEmail);
    _paymentOptions['show_address'].addPrefData(keyShowAddress);

    _showMessage("Configuration updated successfully");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration"),
      ),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium,
                  const TextSpan(
                    children: [
                      TextSpan(
                        text: "Merchant: Geidea Gateway KSA ",
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _merchant(),
              _verticalSizeBox,
              Text(
                "SDK Language",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _verticalSizeBox,
              TabSelector(
                  title1: 'English',
                  title2: 'Arabic',
                  selectedTitle: _language,
                  onClick: (type) {
                    setState(() {
                      _language = type;
                    });
                    (type == "English" ? "EN" : "AR")
                        .addPrefData(keySdkLanguage);
                  }),
              PaymentDetail(
                  savedPaymentOperation: _savedPaymentOperation,
                  paymentOperations: _paymentOperations,
                  currencyController: _currencyController,
                  callbackUrlController: _callbackUrlController,
                  returnUrlController: _returnUrlController,
                  merchantReferenceIdController: _merchantReferenceIdController,
                  paymentOptions: _paymentOptions,
                  onCheckChange: (key, value) {
                    setState(() {
                      _paymentOptions[key] = value ?? false;
                    });
                  }),
              _verticalSizeBox,
              Text(
                "Customer details (Checkout Screen)",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _verticalSizeBox,
              TextFormField(
                controller: _customerEmailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: "Customer email",
                  counterText: "",
                ),
              ),
              _verticalSizeBox,
              Text(
                "Billing address",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _verticalSizeBox,
              Address(
                city: _billingCity,
                street: _billingStreet,
                countryCode: _billingCountryCode,
                postalCode: _billingPostalCode,
              ),
              _verticalSizeBox,
              Text(
                "Shipping address",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              CheckboxListTile(
                title: Text(
                  "Shipping Address same as Billing Address",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                value: _shippingSameAsBilling,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _shippingCity.text = _billingCity.text.toString();
                      _shippingStreet.text = _billingStreet.text.toString();
                      _shippingCountryCode.text =
                          _billingCountryCode.text.toString();
                      _shippingPostalCode.text =
                          _billingPostalCode.text.toString();
                    }
                    _shippingSameAsBilling = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              Address(
                city: _shippingCity,
                street: _shippingStreet,
                countryCode: _shippingCountryCode,
                postalCode: _shippingPostalCode,
              ),
              Text(
                "UI color schemes",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _colorWidget(
                  "Text Color",
                  _colorText,
                  () => colorPickerDialog(
                      _colorText,
                      (selectedColor) => setState(() {
                            _colorText = selectedColor;
                            selectedColor.hex.addPrefData(keyColorText);
                          }))),
              _colorWidget(
                  "Card Color",
                  _colorCard,
                  () => colorPickerDialog(
                      _colorCard,
                      (selectedColor) => setState(() {
                            _colorCard = selectedColor;
                            selectedColor.hex.addPrefData(keyColorCard);
                          }))),
              _colorWidget(
                  "Pay button Color",
                  _colorPayButton,
                  () => colorPickerDialog(
                      _colorPayButton,
                      (selectedColor) => setState(() {
                            _colorPayButton = selectedColor;
                            selectedColor.hex.addPrefData(keyColorPayButton);
                          }))),
              _colorWidget(
                  "Cancel button Color",
                  _colorCancelButton,
                  () => colorPickerDialog(
                      _colorCancelButton,
                      (selectedColor) => setState(() {
                            _colorCancelButton = selectedColor;
                            selectedColor.hex.addPrefData(keyColorCancelButton);
                          }))),
              _colorWidget(
                  "Background Color",
                  _colorBG,
                  () => colorPickerDialog(
                      _colorBG,
                      (selectedColor) => setState(() {
                            _colorBG = selectedColor;
                            selectedColor.hex.addPrefData(keyColorBG);
                          }))),
            ],
          ),
        ),
      ),
      if (globals.keyMerchantKey?.isNotEmpty == true &&
          globals.keyMerchantPass?.isNotEmpty == true)
        ElevatedButton(
          onPressed: () => _saveData(),
          child: Center(
            child: Text("Save".toUpperCase()),
          ),
        ),
    ]);
  }

  Widget _merchant() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
      child: Column(
        children: [
          MyDropDown(
            hint: "Select environment",
            initialValue: globals.keyEnv.title,
            items: _baseUrlType.map((e) => e.title).toList(),
            keyPref: "",
            onChange: (value) {
              globals.keyEnv = _baseUrlType
                  .firstWhere((element) => element.title == value);
            },
          ),
          _verticalSizeBox,
          TextFormField(
            controller: _merchantKeyController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(),
              labelText: "Merchant key",
              counterText: "",
            ),
          ),
          _verticalSizeBox,
          TextFormField(
            controller: _merchantPasswordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            obscureText: true,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(),
              labelText: "Merchant password",
              counterText: "",
            ),
          ),
          _verticalSizeBox,
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (globals.keyMerchantKey?.isNotEmpty == true ||
                    globals.keyMerchantPass?.isNotEmpty == true) {
                  globals.keyMerchantKey = null;
                  globals.keyMerchantPass = null;
                  _merchantKeyController.text = "";
                  _merchantPasswordController.text = "";
                } else {
                  globals.keyMerchantKey =
                      _merchantKeyController.text.toString();
                  globals.keyMerchantPass =
                      _merchantPasswordController.text.toString();
                }
              });
            },
            child: Center(
              child: Text(((globals.keyMerchantKey?.isNotEmpty == true ||
                          globals.keyMerchantPass?.isNotEmpty == true)
                      ? "Clear"
                      : "Store")
                  .toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorWidget(String title, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          InkWell(
            onTap: () => onTap(),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> colorPickerDialog(
      Color initialColor, Function(Color) onChangeColor) async {
    return ColorPicker(
      color: initialColor,
      onColorChanged: (Color color) => onChangeColor(color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      // transitionBuilder: (BuildContext context, Animation<double> a1,
      //     Animation<double> a2, Widget widget) {
      //   final double curvedValue =
      //       Curves.easeInOutBack.transform(a1.value) - 1.0;
      //   return Transform(
      //     transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
      //     child: Opacity(
      //       opacity: a1.value,
      //       child: widget,
      //     ),
      //   );
      // },
      // transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
