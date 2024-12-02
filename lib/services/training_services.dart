import 'dart:convert';
import 'package:http/http.dart' as http;

class TrainingService {
  final String _baseURL = 'rpfit-c0f07-default-rtdb.europe-west1.firebasedatabase.app';

  Future<Map<String, dynamic>?> getAllTrainingData() async {
    final urlPowerlifting = Uri.https(_baseURL, 'EntrenamientoPowerlifting.json');
    final urlBodybuilding = Uri.https(_baseURL, 'EntrenamientoBodybuilding.json');

    final responses = await Future.wait([http.get(urlPowerlifting), http.get(urlBodybuilding)]);

    if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
      final powerliftingData = json.decode(responses[0].body) as Map<String, dynamic>?;
      final bodybuildingData = json.decode(responses[1].body) as Map<String, dynamic>?;
      
      return {
        'EntrenamientoPowerlifting': powerliftingData,
        'EntrenamientoBodybuilding': bodybuildingData,
      };
    } else {
      print('Error al obtener datos de entrenamiento.');
      return null;
    }
  }
}
