import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final Uri allCurrencyUrl = Uri.https(
    "api.fastforex.io",
    "/fetch-all",
    {
      "accept": "application/json",
      "api_key": "dfebadbc9a-e216fed717-rolnh7",
    },
  );

  Future<List<String>> getCurrencies() async {
    http.Response res = await http.get(allCurrencyUrl);

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["results"].keys.toList();
    } else {
      throw Exception("Failed to connect to API");
    }
  }

  Future<Map<String, dynamic>> convert(
      String from, String to, double amount) async {
    final Uri converterUrl = Uri.https(
      "api.fastforex.io",
      "/convert",
      {
        "accept": "application/json",
        "api_key": "dfebadbc9a-e216fed717-rolnh7",
        "from": from,
        "to": to,
        "amount": amount,
      }.map((key, value) => MapEntry(key, value.toString())),
    );

    http.Response res = await http.get(converterUrl);

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to connect to API");
    }
  }
}
