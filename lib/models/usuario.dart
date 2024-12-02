import 'dart:convert';


class Usuario {
  String? id; 
  int altura; // Mantenido como int
  String apellidos;
  String disciplina;
  int edad;
  String email;
  String nombre;
  double peso;
  String telefono; 

  Usuario({
    this.id,
    required this.altura,
    required this.apellidos,
    required this.disciplina,
    required this.edad,
    required this.email,
    required this.nombre,
    required this.peso,
    required this.telefono,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) {
    return Usuario(
      altura: json["altura"] ?? 0, // Si es null, asigna 0
      apellidos: json["apellidos"] ?? "", // Si es null, asigna una cadena vacía
      disciplina: json["disciplina"] ?? "", // Si es null, asigna una cadena vacía
      edad: json["edad"] ?? 0, // Si es null, asigna 0
      email: json["email"] ?? "", // Si es null, asigna una cadena vacía
      nombre: json["nombre"] ?? "", // Si es null, asigna una cadena vacía
      peso: json["peso"]?.toDouble(),// Si es null, asigna 0
      telefono: json["telefono"] ?? "", // Si es null, asigna una cadena vacía
    );
  }

  Map<String, dynamic> toMap() => {
    "altura": altura, // Mantenido como int
    "apellidos": apellidos,
    "disciplina": disciplina,
    "edad": edad,
    "email": email,
    "nombre": nombre,
    "peso": peso,
    "telefono": telefono
  };

  Usuario copy() => Usuario(
    email: email, 
    apellidos: apellidos,
    nombre: nombre,
    edad: edad, 
    altura: altura, // Mantenido como int
    peso: peso,
    disciplina: disciplina,
    telefono: telefono,
    id: id
  );
}
