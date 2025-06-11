import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final titlecontrol = TextEditingController();
  final contentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notas Diarias"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 187, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "Mis Notas",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: titlecontrol,
                    decoration: InputDecoration(
                      labelText: 'Titulo',
                      hintText: 'Ingresar Titulo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: contentcontroller, // ← corregido
                    decoration: InputDecoration(
                      labelText: 'Contenido',
                      hintText: 'Ingresar Contenido',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (titlecontrol.text.isEmpty ||
                          contentcontroller.text.isEmpty) {
                      } else {
                        FirebaseFirestore.instance.collection('notes').add({
                          'title': titlecontrol.text.trim(),
                          'contenido': contentcontroller.text.trim(),
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        titlecontrol.clear();
                        contentcontroller.clear();
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ),
            Expanded(
              // ← Para que ListView no cause error
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection(
                          'notes',
                        ) // ← Asegúrate de usar el mismo nombre
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return Center(child: Text('No hay notas agregadas'));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final title = doc['title'];
                      final content = doc['contenido'];

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(content),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('notes')
                                .doc(doc.id)
                                .delete();
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: const Color.fromARGB(255, 255, 7, 7),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
