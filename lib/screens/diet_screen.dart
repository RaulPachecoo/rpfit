import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rpfit/models/usuario.dart';
import 'package:rpfit/services/diet_services.dart';
import 'package:rpfit/services/auth_services.dart';

class DietScreen extends StatefulWidget {
  final String email;

  const DietScreen({Key? key, required this.email}) : super(key: key);

  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  Usuario? _currentUser;
  String? _dietType;
  Map<String, String>? _diet;
  bool _isLoading = true;

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
          _calculateIMCAndSelectDiet();
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

  void _calculateIMCAndSelectDiet() {
    if (_currentUser != null) {
      double alturaEnMetros = _currentUser!.altura / 100;
      double imc = _currentUser!.peso / pow(alturaEnMetros, 2);

      if (imc >= 23.5) {
        _dietType = "DietaDefinición";
      } else {
        _dietType = "DietaVolumen";
      }

      _loadDietData();
    }
  }

  Future<void> _loadDietData() async {
    try {
      Map<String, Map<String, String>>? diets = await DietService().getAllDietData();
      if (diets != null && _dietType != null) {
        setState(() {
          _diet = diets[_dietType];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar las dietas: $e');
      setState(() {
        _isLoading = false;
      });
    }
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

    if (_currentUser == null || _diet == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No se pudo cargar la dieta.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    List<String> mealOrder = ['Desayuno', 'MediaMañana', 'Comida', 'Merienda', 'Cena'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dieta'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: mealOrder.map((meal) {
            String? details = _diet![meal];
            if (details == null) {
              return SizedBox.shrink();
            }
            // Split the details into a list and add bullet points
            List<String> detailsList = details.split(', ');
            String formattedDetails = detailsList.map((item) => '• $item').join('\n');
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
                      meal,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDetails,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
