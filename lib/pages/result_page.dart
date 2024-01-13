import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:main_app_flutter/core/res/app.dart';
import 'package:main_app_flutter/core/routes/routes.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.text});
  final String text;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final TextEditingController _titleController = TextEditingController();
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.text);
  }

  String _selectedSection = 'Estudio';
  final List<String> _sections = [
    'Estudio',
    'Desarrollo',
    'Personal',
    'Descanso'
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedSection,
              onChanged: (value) {
                setState(() {
                  _selectedSection = value!;
                });
              },
              items: _sections.map((section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Sección'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Contenido'),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String filePath = AppConstants.notes;
                String fileContent = await rootBundle.loadString(filePath);
                List<dynamic> existingData = json.decode(fileContent);

                // Agregar la nueva nota
                existingData.add({
                  "titulo": _titleController.text,
                  "categoria": _selectedSection,
                  "contenido": _contentController.text,
                });

                // Guardar los datos actualizados en el archivo
                String jsonData = json.encode(existingData);
                await rootBundle.loadString(filePath);

                // Navegar a la pantalla principal
                Navigator.pushReplacementNamed(context, Routes.home);
              },
              child: Text('GUARDAR'),
            ),
          ],
        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nota'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(widget.text), // Accede al atributo text con widget.text
        ),
      ),
    );
  }
*/
}
