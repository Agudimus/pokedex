// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMonster extends StatelessWidget {
  AddMonster({super.key});

  final monsterGroups = [
    'Normal',
    'Fire',
    'Water',
    'Grass',
    'Electric',
    'Ice',
    'Fighting',
    'Poison',
    'Ground',
    'Flying',
    'Psychic',
    'Bug',
    'Rock',
    'Ghost',
    'Dark',
    'Dragon',
    'Steel',
    'Fairy',
  ];
  String? selectedGruop;

  final CollectionReference monster =
      FirebaseFirestore.instance.collection('monster');

  TextEditingController nameController = TextEditingController();
  TextEditingController powerController = TextEditingController();

  void addPokemon() {
    final data = {
      'name': nameController.text,
      'power': powerController.text.toString(),
      'group': selectedGruop,
    };
    monster.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Tambah Pokemon'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama Pokemon',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: powerController,
              decoration: InputDecoration(
                labelText: 'Power Pokemon',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            SizedBox(height: 16.0),
            Text('Group'),
            DropdownButtonFormField(
              value: selectedGruop,
              onChanged: (value) {
                selectedGruop = value;
              },
              items: monsterGroups.map((monsterGroup) {
                return DropdownMenuItem(
                  value: monsterGroup,
                  child: Text(monsterGroup),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: () {
                  addPokemon();
                  Navigator.pop(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
