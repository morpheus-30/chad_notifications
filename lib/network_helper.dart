import 'package:http/http.dart' as http;

class NetworkHelper {
  Future getData(String url) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    return response.body;
  }
}
