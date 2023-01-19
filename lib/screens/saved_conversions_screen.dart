import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_app/constants/app_colors.dart';
import 'package:new_app/providers/user_provider.dart';

class SavedConversionsScreen extends StatelessWidget {
  const SavedConversionsScreen({Key? key}) : super(key: key);
  static const screenRoute = 'saved-conversions-screen';

  Future<List> _getSavedConversions(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedConversions =
        prefs.getStringList(context.read<UserProvider>().userId);

    final decodedConversions = encodedConversions
        ?.map((conversion) => json.decode(conversion))
        .toList();

    return decodedConversions!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Conversions")),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<List>(
            future: _getSavedConversions(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final conversion = snapshot.data![index];
                      final resultCurrency =
                          conversion['result'].keys.toList()[0];
                      final conversionResult =
                          conversion['result'][resultCurrency];

                      return ExpansionTile(
                        textColor: appColors.shade900,
                        childrenPadding: const EdgeInsets.only(
                          left: 14,
                          bottom: 14,
                          right: 14,
                        ),
                        title: Text(
                          "${conversion['amount']} ${conversion['base']} = $conversionResult $resultCurrency",
                        ),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd – kk:mm:ss')
                              .format(DateTime.parse(conversion['date'])),
                        ),
                        children: <Widget>[
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount: ${conversion['amount']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appColors.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Base: ${conversion['amount']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appColors.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Result: ${conversion['amount']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appColors.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Conversion Currency: $resultCurrency',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appColors.shade700,
                                    ),
                                  ),
                                  Text(
                                    'Rate: ${conversion['result']['rate'].toString()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: appColors.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
