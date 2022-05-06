import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper();

  Future<dynamic> getData(String url) async {
    http.Response resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      print('kore ${resp.statusCode}');
      var decodedBody = jsonDecode(resp.body);
      print(decodedBody);
      return decodedBody;
    } else {
      await Future.delayed(Duration(seconds: 1));
      return jsonDecode("{\"bid\": 35644.30}");
    }
  }
}
