import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post_model.dart';

Future<List<Post>> fetchPosts() async {
  final response = await http.post(
    Uri.parse(
      'https://finansuenos.cuotasoft.com/api_creacion_prospecto_finan/',
    ),
    headers: {
      'Content-Type': 'application/json',
      'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
    },
    body: json.encode({
      "operacion": "consulta_prospectos_asesor",
      "id_asesor": "1105928884",
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print("informacion obtenida $data");

    // Asegúrate que la respuesta es una lista o tiene una lista
    final List<dynamic> jsonResponse = data is List ? data : data['data'];

    return jsonResponse.map((post) => Post.fromJson(post)).toList();
  } else {
    print('Error: ${response.body}');
    throw Exception('Error al cargar las publicaciones');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio de API de Flutter',
      home: const PostList(),
    );
  }
}

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
    //fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos de la API')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error al cargar los datos.'),
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futurePosts =
                            fetchPosts(); // Reintentar cargar los datos
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cédula: ${post.identificacion}'),
                      Text('Celular: ${post.celular}'),
                      Text('Correo: ${post.correo}'),
                      Text('Valor solicitado: \$${post.valorSolicitado}'),
                      Text(
                        'Dirección: ${post.direccion}, Barrio: ${post.barrio}',
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            );
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
