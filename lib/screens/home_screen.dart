import 'package:flutter/material.dart';
import 'package:rpfit/screens/map_screen.dart';
import 'package:rpfit/screens/account_screen.dart';
import 'package:rpfit/screens/training_screen.dart';
import 'package:rpfit/screens/motivation_screen.dart';
import 'package:rpfit/screens/diet_screen.dart'; // Importa la nueva pantalla de dieta

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Center(
          child: Text(
            'RPFit',
            style: TextStyle(
              fontFamily: 'Courgette',
              fontSize: 24,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: _currentPageIndex,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded, color: Colors.white),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/tridente.png'), color: Colors.white),
            label: 'Motivation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, color: Colors.white),
            label: 'Account',
          ),
        ],
      ),
      body: _buildBody(), 
    );
  }

  Widget _buildBody() {
    switch (_currentPageIndex) {
      case 0:
        return HomeScreenContent(email: widget.email);
      case 1:
        return  MapScreen();
      case 2:
        return  MotivationScreen();
      case 3:
        return AccountScreen(email: widget.email);
      default:
        return const SizedBox.shrink();
    }
  }
}

class HomeScreenContent extends StatelessWidget {
  final String email;

  const HomeScreenContent({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Color de fondo negro
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/cbum.jpg', // Reemplaza con tu imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          // Contenido con opacidad para mejorar la legibilidad
          Container(
            color: Colors.black.withOpacity(0.6), // Ajustar la opacidad del fondo
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainingScreen(email: email),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 69, 143, 255), // Color del botón
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Entrenamiento',
                        style: TextStyle(color: Colors.black), // Color del texto
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio entre los botones
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DietScreen(email: email),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 255, 199, 77), // Color del botón
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Dieta',
                        style: TextStyle(color: Colors.black), // Color del texto
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}