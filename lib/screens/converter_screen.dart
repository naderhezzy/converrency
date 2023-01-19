import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_app/screens/saved_conversions_screen.dart';
import 'package:new_app/widgets/dialogs/settings_dialog.dart';
import 'package:new_app/constants/app_colors.dart';
import 'package:new_app/providers/user_provider.dart';
import 'package:new_app/services/api_client.dart';
import 'package:new_app/widgets/converter_control.dart';
import 'package:new_app/widgets/dialogs/saving_succes_dialog.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({Key? key}) : super(key: key);
  static const screenRoute = 'converter-screen';

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _apiClient = ApiClient();
  final _inputController = TextEditingController();

  Timer? _debounce;
  String? _conversionResultAmount;
  Map<String, dynamic>? _conversionResult;

  void _onChange(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 750), _fetchConversion);
  }

  void _fetchConversion() async {
    if (_inputController.text.isEmpty) {
      setState(() => _conversionResultAmount = "");
      return;
    } else if (double.parse(_inputController.text) == 0) {
      setState(() => _conversionResultAmount = "0.00");
      return;
    }

    _conversionResult = await _apiClient.convert(
      context.read<UserProvider>().fromCurrency,
      context.read<UserProvider>().toCurrency,
      double.parse(_inputController.text),
    );

    setState(() {
      _conversionResultAmount = _conversionResult?["result"]
              [context.read<UserProvider>().toCurrency]
          .toString();
    });
  }

  void _saveConversion() async {
    if (_inputController.text.isEmpty) return;

    final _userId = context.read<UserProvider>().userId;
    final prefs = await SharedPreferences.getInstance();
    final conversionsList = prefs.getStringList(_userId);

    _conversionResult?["date"] = DateTime.now().toString();

    if (conversionsList == null) {
      prefs.setStringList(_userId, [json.encode(_conversionResult)]);
    } else {
      conversionsList.add(json.encode(_conversionResult));
      prefs.setStringList(_userId, conversionsList);
    }

    showCustomDialog(const SavingSuccessDialog());
  }

  void showCustomDialog(dialog) async {
    await showGeneralDialog(
      transitionBuilder: (_, animation, __, ___) {
        final curvedValue =
            Curves.easeInOutBack.transform(animation.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: animation.value,
            child: dialog,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) => Container(),
    );
  }

  void _changeUserName(String newUserName) async {
    context.read<UserProvider>().setUserName(newUserName);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(newUserName, context.read<UserProvider>().userId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(SavedConversionsScreen.screenRoute),
                child: const Icon(
                  Icons.history,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showCustomDialog(SettingsDialog(onSubmit: _changeUserName));
                },
                child: const Icon(Icons.settings),
              )),
        ],
        title: const Text("Converter"),
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Hi ${context.read<UserProvider>().userName}!",
                style: TextStyle(
                  color: appColors.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConverterControl(onSwap: () => _fetchConversion()),
              Column(
                children: <Widget>[
                  TextField(
                    controller: _inputController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    decoration: InputDecoration(
                      hintText: "Enter your amount",
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      suffixText: context.watch<UserProvider>().fromCurrency,
                    ),
                    onChanged: _onChange,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(),
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 32),
                          children: <TextSpan>[
                            TextSpan(text: '${_conversionResultAmount ?? ''} '),
                            TextSpan(
                                text: _inputController.text.isNotEmpty
                                    ? context.watch<UserProvider>().toCurrency
                                    : "",
                                style: const TextStyle(fontSize: 24))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _inputController.clear();
                          _conversionResultAmount = null;
                          FocusScope.of(context).unfocus();
                        });
                      },
                      child: const Text(
                        "Discard",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                        width: 2,
                        color: appColors.shade500,
                        style: BorderStyle.solid,
                      )),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveConversion,
                      child: const Text(
                        "Save",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
