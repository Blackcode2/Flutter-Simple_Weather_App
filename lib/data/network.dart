import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  final String url;
  Network(this.url);

  Future<dynamic> getJsonData() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    }
  }
}
