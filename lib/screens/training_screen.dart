import 'package:flutter/material.dart';
import 'package:rpfit/models/usuario.dart';
import 'package:rpfit/services/auth_services.dart';
import 'package:rpfit/services/training_services.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  Usuario? _currentUser;
  List<MapEntry<String, dynamic>>? _userTrainingData;
  bool _isLoading = true;
  bool _showBeginnerTraining = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(widget.email);
  }

  Future<void> _loadUserData(String email) async {
    try {
      Usuario? usuario = await AuthService().loadUsuarios(email);
      if (usuario != null) {
        setState(() {
          _currentUser = usuario;
          _loadTrainingData();
        });
      } else {
        print('Error: No se pudo cargar la información del usuario.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar la información del usuario: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTrainingData() async {
    try {
      TrainingService trainingService = TrainingService();
      Map<String, dynamic>? trainingData = await trainingService.getAllTrainingData();
      if (trainingData != null && _currentUser != null) {
        String disciplina = _currentUser!.disciplina;
        String key = disciplina == 'Powerlifting' ? 'EntrenamientoPowerlifting' : 'EntrenamientoBodybuilding';
        String level = _showBeginnerTraining ? 'Principiantes' : 'Intermedios';
        setState(() {
          _userTrainingData = trainingData[key][level].entries.toList();
          _userTrainingData!.sort((a, b) => _sortWeekDays(a.key, b.key, disciplina));
          _isLoading = false;
        });
      } else {
        print('Error al cargar los datos de entrenamiento.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar los datos de entrenamiento: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _sortWeekDays(String a, String b, String disciplina) {
    List<String> weekDaysOrder = ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'];
    return weekDaysOrder.indexOf(a) - weekDaysOrder.indexOf(b);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_currentUser == null || _userTrainingData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No se pudo cargar los entrenamientos.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Entrenamiento'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Text('Principiante', style: TextStyle(color: Colors.white)),
              Switch(
                value: _showBeginnerTraining,
                onChanged: (value) {
                  setState(() {
                    _showBeginnerTraining = value;
                    _loadTrainingData();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _userTrainingData!.map((entry) {
            return Card(
              color: Colors.grey[900],
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        children: entry.value.split(',').map<TextSpan>((exercise) {
                          return TextSpan(
                            text: '• ' + exercise.trim() + '\n',
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
