import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpfit/models/usuario.dart';
import 'package:rpfit/ui/input_decorations.dart';
import 'package:rpfit/services/auth_services.dart';
import 'package:rpfit/widgets/card_container.dart';
import 'package:rpfit/widgets/auth_background.dart';
import 'package:rpfit/providers/register_form_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Regístrate', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: _RegisterForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())
                ),
                child: const Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    if ((registerForm.disciplina != 'Powerlifting' &&
            registerForm.disciplina != 'Bodybuilding')) {
      registerForm.disciplina = 'Powerlifting'; // O 'Bodybuilding'
    }


    return Form(
      key: registerForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (value) => registerForm.nombre = value,
            validator: (value) {
              return (value != null && value.isNotEmpty)
                  ? null
                  : 'Por favor, ingrese su nombre';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Apellidos',
              prefixIcon: Icon(Icons.person),
            ),
            onChanged: (value) => registerForm.apellidos = value,
            validator: (value) {
              return (value != null && value.isNotEmpty)
                  ? null
                  : 'Por favor, ingrese sus apellidos';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Edad',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => registerForm.edad = int.tryParse(value) ?? 0,
            validator: (value) {
              return (value != null && int.tryParse(value) != null)
                  ? null
                  : 'Por favor, ingrese una edad válida';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Altura (cm)',
              prefixIcon: Icon(Icons.height),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => registerForm.altura = int.tryParse(value) ?? 0,
            validator: (value) {
              return (value != null && int.tryParse(value) != null)
                  ? null
                  : 'Por favor, ingrese una altura válida';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              prefixIcon: Icon(Icons.fitness_center),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => registerForm.peso = double.parse(value),
            validator: (value) {
              return (value != null)
                  ? null
                  : 'Por favor, ingrese un peso válido';
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: registerForm.disciplina, // Valor inicial
            onChanged: (value) => registerForm.disciplina = value ?? '',
            decoration: const InputDecoration(
              labelText: 'Disciplina',
              prefixIcon: Icon(Icons.sports_handball),
            ),
            items: ['Powerlifting', 'Bodybuilding'] // Opciones válidas
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              return (value != null && value.isNotEmpty)
                  ? null
                  : 'Por favor, seleccione una disciplina';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'example@gmail.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_outlined
            ),
            onChanged: (value) => registerForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
    
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no luce como un correo';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
            ),
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6 && value.length <= 12)
                  ? null
                  : 'La contraseña debe tener entre 6 y 12 caracteres';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              prefixIcon: Icon(Icons.phone),
            ),
            onChanged: (value) => registerForm.tlf = value,
            validator: (value) {
              return (value != null && value.isNotEmpty && value.length == 9)
                  ? null
                  : 'Por favor, ingrese un número de teléfono válido';
            },
          ),
          const SizedBox(height: 30),
          
          MaterialButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final authService = AuthService();

              if (!registerForm.isValidForm()) return;

              registerForm.isLoading = true;

              final String? errorMessage =
                  await authService.createUser(
                      registerForm.email,
                      registerForm.password,
                      Usuario(
                        id: "",
                        email: registerForm.email,
                        peso: registerForm.peso,
                        edad: registerForm.edad,
                        altura: registerForm.altura,
                        apellidos: registerForm.apellidos,
                        nombre: registerForm.nombre,
                        telefono: registerForm.tlf,
                        disciplina: registerForm.disciplina, // Usar el valor seleccionado de la disciplina
                      ));
              authService
                  .loadUsuarios(registerForm.email)
                  .then((user) => {
                    if (errorMessage == null) {
                      // Redirigir a la pantalla de inicio de sesión
                      Navigator.pushReplacementNamed(context, 'login'),
                    } else {
                      // Mostrar error en la terminal
                      print(errorMessage),
                      registerForm.isLoading = false,
                    }
                  });
            },
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: const Color.fromARGB(255, 12, 12, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: Text(
                registerForm.isLoading ? 'Espere' : 'Registrarse',
                style: const TextStyle(color: Colors.white), // Texto blanco
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}
