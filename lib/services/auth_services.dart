import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rpfit/models/usuario.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCa7cPVIqAmyo0fA3vf20oTCJs81TxJSZQ';
  
  // Si devolvemos algo, es un error, si no, todo correcto
  Future<String?> createUser(String email, String password, Usuario usuario) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });   
    
    final resp = await http.post(url, body: json.encode(authData));
    
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Crear el usuario en la base de datos
      final userId = await addUser(usuario);
      if (userId != null) {
        usuario.id = userId;
        return null;
      } else {
        return 'Error al crear el usuario en la base de datos';
      }
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> addUser(Usuario usuario) async {
    final String _baseURL = 'rpfit-c0f07-default-rtdb.europe-west1.firebasedatabase.app';

    final url = Uri.https(_baseURL, 'Usuarios.json');
    final resp = await http.post(url, body: usuario.toJson());
    if (resp.statusCode == 200) {
      final responseData = json.decode(resp.body);
      print('Usuario insertado con éxito en la base de datos');
      return responseData['name']; // Firebase devuelve el ID en el campo 'name'
    } else {
      print('Error al insertar el usuario en la base de datos. Código de estado: ${resp.statusCode}');
      throw Exception('Error');
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<Usuario?> loadUsuarios(String email) async {
    final String _baseURL = 'rpfit-c0f07-default-rtdb.europe-west1.firebasedatabase.app';
    final url = Uri.https(_baseURL, 'Usuarios.json'); // URL de la base de datos
    final resp = await http.get(url); // Petición HTTP para obtener los datos
    Usuario? validUser;
    final Map<String, dynamic> usuariosMap = json.decode(resp.body); // Decodificar la respuesta JSON
    usuariosMap.forEach((key, value) {
      Usuario usuario = Usuario.fromMap(value);
      usuario.id = key;
      if (usuario.email.compareTo(email) == 0) {
        validUser = usuario;
      }
    });
    return validUser;
  }

  Future<String?> updateUser(Usuario usuario) async {
    final String _baseURL = 'rpfit-c0f07-default-rtdb.europe-west1.firebasedatabase.app';

    final url = Uri.https(_baseURL, 'Usuarios/${usuario.id}.json');
    final resp = await http.put(url, body: usuario.toJson());
    if (resp.statusCode == 200) {
      print('Usuario actualizado con éxito en la base de datos');
      return null;
    } else {
      print('Error al actualizar el usuario en la base de datos. Código de estado: ${resp.statusCode}');
      return 'Error al actualizar el usuario en la base de datos';
    }
  }
}
