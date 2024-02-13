import 'package:shared_preferences/shared_preferences.dart';

const String keySdkLanguage = "keySdkLanguage";
const String keyCurrency = "keyCurrency";
const String keyCallbackUrl = "keyCallbackUrl";
const String keyReturnUrl = "keyReturnUrl";
const String keyShowEmail = "keyShowEmail";
const String keyShowAddress = "keyShowAddress";
const String keyMerchantRefId = "keyMerchantRefId";
const String keyCustomerEmail = "keyCustomerEmail";
const String keyAmount = "keyAmount";
const String keyPaymentType = "keyPaymentType";
const String keyCardNumber = "keyCardNumber";
const String keyCardExpMonth = "keyCardExpMonth";
const String keyCardExpYear = "keyCardExpYear";
const String keyCardCVV = "keyCardCVV";
const String keyCardHolderName = "keyCardHolderName";
const String keyBillingCity = "keyBillingCity";
const String keyBillingStreet = "keyBillingStreet";
const String keyBillingCountryCode = "keyBillingCountryCode";
const String keyBillingPostalCode = "keyBillingPostalCode";
const String keyShippingCity = "keyShippingCity";
const String keyShippingStreet = "keyShippingStreet";
const String keyShippingCountryCode = "keyShippingCountryCode";
const String keyShippingPostalCode = "keyShippingPostalCode";
const String keyPaymentOperation = "keyPaymentOperation";
const String keyColorBG = "keyColorBG";
const String keyColorCard = "keyColorCard";
const String keyColorText = "keyColorText";
const String keyColorPayButton = "keyColorPayButton";
const String keyColorCancelButton = "keyColorCancelButton";

class _AppPreference {
  static Future<void> addData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value;
  }

  static Future<void> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> deleteAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

extension AppPreferences on dynamic {
  Future<String> addPrefData(String key) async {
    await _AppPreference.addData(key, toString());
    return toString();
  }

  Future<String?> getPrefData() async =>
      await _AppPreference.getData(toString());

  get deletePrefData => _AppPreference.deleteData(toString());

  get deleteAllPrefData => _AppPreference.deleteAllData();
}
