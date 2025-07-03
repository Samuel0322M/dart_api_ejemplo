//import 'dart:convert'; // Importar para la decodificación JSON

class Post {
  final int identificacion;
  final String nombre;
  final String celular;
  final String correo;
  final String valorSolicitado;
  final String direccion;
  final String barrio;
  final String? selfie;
  final String? fotoAntCedula;
  final String? fotoPosCedula;

  Post({
    required this.identificacion,
    required this.nombre,
    required this.celular,
    required this.correo,
    required this.valorSolicitado,
    required this.direccion,
    required this.barrio,
    this.selfie,
    this.fotoAntCedula,
    this.fotoPosCedula,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      identificacion: int.parse(json['identificacion']),
      nombre: json['nombre_prospecto'],
      celular: json['celular'].toString(),
      correo: json['correo'],
      valorSolicitado: json['valor_solicitado'].toString(),
      direccion: json['direccion_residencia'],
      barrio: json['barrio_residencia'],
      selfie: json['Selfie']?.toString(),
      fotoAntCedula: json['foto_ant_cedula']?.toString(),
      fotoPosCedula: json['foto_pos_cedula']?.toString(),
    );
  }
  
}
