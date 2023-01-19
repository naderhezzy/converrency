import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_app/screens/converter_screen.dart';
import 'package:new_app/widgets/converter_control.dart';
import 'package:new_app/services/api_client.dart';
import 'package:new_app/providers/user_provider.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final Uuid _uuid = const Uuid();
  final ApiClient _apiClient = ApiClient();

  final TextEditingController _userNameController = TextEditingController();
  bool _userNameError = false;

  Future<List<String>> _getCurrencyList() async {
    final currencyList = await _apiClient.getCurrencies();
    return currencyList;
  }

  void _onStartPressed() async {
    if (_userNameController.text.isEmpty) {
      setState(() => _userNameError = true);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userNameController.text);

    if (userId == null) {
      final String id = _uuid.v1();
      context.read<UserProvider>().setUserId(id);
      prefs.setString(_userNameController.text, id);
    } else {
      context.read<UserProvider>().setUserId(userId);
    }

    context.read<UserProvider>().setUserName(_userNameController.text);

    Navigator.of(context).pushNamed(ConverterScreen.screenRoute);
  }

  @override
  void initState() {
    super.initState();
    final currencyList = _getCurrencyList();
    context.read<UserProvider>().setCurrencies(currencyList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Converrency"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(
                  controller: _userNameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Username",
                    errorText:
                        _userNameError ? "Please enter a username" : null,
                  ),
                  onSubmitted: (_) => _onStartPressed(),
                ),
                Column(
                  children: const [
                    Text("Default Conversion"),
                    SizedBox(height: 30),
                    ConverterControl(),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onStartPressed,
                    child: const Text(
                      "Start",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
