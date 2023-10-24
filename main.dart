import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(NotasApp());
}

class Nota {
  final String title;
  final String content;

  Nota(this.title, this.content);
}

class NotasProvider with ChangeNotifier {
  List<Nota> _notas = [];

  List<Nota> get notas => _notas;

  void agregarNota(Nota nota) {
    _notas.add(nota);
    notifyListeners();
  }

  void eliminarNota(int index) {
    _notas.removeAt(index);
    notifyListeners();
  }
}

class NotasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotasProvider(),
      child: MaterialApp(
        home: PantallaPrincipal(),
      ),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notasProvider = Provider.of<NotasProvider>(context);
    final notas = notasProvider.notas;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notas Rápidas'),
      ),
      body: ListView.builder(
        itemCount: notas.length,
        itemBuilder: (context, index) {
          final nota = notas[index];
          return Dismissible(
            key: Key(nota.title),
            onDismissed: (direction) {
              notasProvider.eliminarNota(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Nota eliminada')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(nota.title),
              subtitle: Text(nota.content),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PantallaCrearNota()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PantallaCrearNota extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notasProvider = Provider.of<NotasProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nota'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null; // El título no está vacío
                  }
                  return 'Por favor, ingrese un título';
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Contenido'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return null; // El contenido no está vacío
                  }
                  return 'Por favor, ingrese contenido';
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final content = _contentController.text;
                    final nota = Nota(title, content);
                    notasProvider.agregarNota(nota);
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar Nota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
