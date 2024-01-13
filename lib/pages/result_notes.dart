import 'package:flutter/material.dart';

class EditNoteHeader extends StatelessWidget {
  final TextEditingController titleController;
  final String selectedSection;
  final TextEditingController noteController;
  final VoidCallback onImageInsertPressed;

  const EditNoteHeader({
    Key? key,
    required this.titleController,
    required this.selectedSection,
    required this.noteController,
    required this.onImageInsertPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EDICIÓN DE NOTA',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 10),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Titulo',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedSection,
          onChanged: (newValue) {
            // Handle section selection
          },
          items: ['Estudio', 'Desarrollo', 'Personal', 'Descanso']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Sección',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: noteController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Apunte',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.image),
              onPressed: onImageInsertPressed,
            ),
          ),
        ),
      ],
    );
  }
}
