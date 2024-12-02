import 'dart:convert';
import 'package:http/http.dart' as http;

class DietService {
  final String _baseURL = 'rpfit-c0f07-default-rtdb.europe-west1.firebasedatabase.app';

  Future<Map<String, Map<String, String>>?> getAllDietData() async {
    final urlDietas = Uri.https(_baseURL, 'Dietas.json');

    final response = await http.get(urlDietas);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>?;
      if (data != null) {
        return data.map((key, value) {
          return MapEntry(key, Map<String, String>.from(value));
        });
      } else {
        print('No se encontraron dietas.');
        return null;
      }
    } else {
      print('Error al obtener datos de dietas.');
      return null;
    }
  }
}
