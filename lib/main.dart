import 'package:flutter/material.dart';
import 'package:rpfit/screens/map_screen.dart';
import 'package:rpfit/screens/home_screen.dart';
import 'package:rpfit/screens/login_screen.dart';
import 'package:rpfit/screens/account_screen.dart';
import 'package:rpfit/screens/register_screen.dart';
import 'package:rpfit/screens/motivation_screen.dart';
import 'package:rpfit/screens/loading_screen.dart'; // Importa la pantalla de carga

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RPFIT',
      initialRoute: 'loading', // Establece la ruta inicial a la pantalla de carga
      routes: {
        'loading': (_) => SplashScreen(),
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'home': (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final String userEmail = args['email'] as String;
          return HomeScreen(email: userEmail);
        },
        'map': (_) => MapScreen(),
        'motivation': (_) => MotivationScreen(),
        'account': (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final String userEmail = args['email'] as String;
          return AccountScreen(email: userEmail);
        },
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simular una operación de carga
    await Future.delayed(Duration(seconds: 3)); // Puedes reemplazar esto con una operación real

    // Navegar a la pantalla de login después de la inicialización
    Navigator.of(context).pushReplacementNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen();
  }
}
