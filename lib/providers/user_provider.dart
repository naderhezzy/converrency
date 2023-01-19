import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userName;
  String? _userId;
  List<String> _currencies = [];
  String _fromCurrency = "EUR";
  String _toCurrency = "USD";

  String get userName => _userName!;
  String get userId => _userId!;
  List<String> get currencies => _currencies;
  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  void setCurrencies(Future<List<String>> fetchedCurrencies) async {
    _currencies = await fetchedCurrencies;
    notifyListeners();
  }

  void setFromCurrency(String currency) {
    _fromCurrency = currency;
    notifyListeners();
  }

  void setToCurrency(String currency) {
    _toCurrency = currency;
    notifyListeners();
  }

  void swapCurrencies() {
    final currentFrom = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = currentFrom;
    notifyListeners();
  }
}
