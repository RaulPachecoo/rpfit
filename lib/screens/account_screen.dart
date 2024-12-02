import 'package:flutter/material.dart';
import 'package:rpfit/models/usuario.dart';
import 'package:rpfit/services/auth_services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  Usuario? _currentUser;

  String? _selectedDisciplina;

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
          _nombreController.text = usuario.nombre;
          _apellidosController.text = usuario.apellidos;
          _edadController.text = usuario.edad.toString();
          _alturaController.text = usuario.altura.toString();
          _pesoController.text = usuario.peso.toString();
          _emailController.text = usuario.email;
          _telefonoController.text = usuario.telefono;
          _selectedDisciplina = usuario.disciplina;
        });
      } else {
        print('Error: No se pudo cargar la información del usuario.');
      }
    } catch (e) {
      print('Error al cargar la información del usuario: $e');
    }
  }

  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      _currentUser!
        ..nombre = _nombreController.text
        ..apellidos = _apellidosController.text
        ..edad = int.parse(_edadController.text)
        ..altura = double.parse(_alturaController.text).toInt()
        ..peso = double.parse(_pesoController.text)
        ..email = _emailController.text
        ..telefono = _telefonoController.text
        ..disciplina = _selectedDisciplina ?? '';

      String? response = await AuthService().updateUser(_currentUser!);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario actualizado con éxito.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el usuario: $response')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _nombreController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ingrese su nombre',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Apellidos',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _apellidosController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ingrese sus apellidos',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Edad',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _edadController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ingrese su edad',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Altura',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _alturaController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ingrese su altura',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Peso',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _pesoController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Ingrese su peso',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Email',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ingrese su email',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Teléfono',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            TextFormField(
              controller: _telefonoController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ingrese su teléfono',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Disciplina',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
            DropdownButtonFormField<String>(
              value: _selectedDisciplina,
              onChanged: (value) {
                setState(() {
                  _selectedDisciplina = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Disciplina',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.sports_handball,
                  color: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              dropdownColor: Colors.black, // Fondo negro para las opciones del menú desplegable
              items: ['Powerlifting', 'Bodybuilding'] // Opciones válidas
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              validator: (value) {
                return (value != null && value.isNotEmpty)
                    ? null
                    : 'Por favor, seleccione una disciplina';
              },
              style: TextStyle(color: Colors.white), // Estilo de texto para el campo seleccionado
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: const Text(
                'Guardar Cambios',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
