// ignore_for_file: file_names

import 'package:http/http.dart' as http;

String getImageUrl(String id) {
  const String imageUrl =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/';

  return '$imageUrl$id.png';
}

class HttpApiClient {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  late final http.Client _client;
  http.Client get client => _client;

  static final HttpApiClient _instance = HttpApiClient._internal();

  factory HttpApiClient() {
    return _instance;
  }

  HttpApiClient._internal() {
    _client = http.Client();
  }
  // final Map<String, String> headers = {
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Bearer YOUR_API_KEY_HERE',
  // };

  void dispose() {
    _client.close();
  }
}
