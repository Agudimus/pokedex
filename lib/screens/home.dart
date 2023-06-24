// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference monster =
      FirebaseFirestore.instance.collection('monster');

  void deleteMonster(id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Pokemon'),
        content: Text('apakah Anda Yakin menghapus pokemon ini?'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete the monster and close the dialog
              monster.doc(id).delete();
              Navigator.of(context).pop();
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Color getRandomColor() {
    final random = Random();
    final hue = random.nextInt(360);
    final pastelColor = HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.8);
    return pastelColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Pokedex App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: monster.orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> monsterList =
                snapshot.data!.docs.cast<DocumentSnapshot>();

            return ListView.builder(
              itemCount: monsterList.length,
              itemBuilder: (context, index) {
                final monsterSnap = monsterList[index];
                final backgroundColor = getRandomColor();

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(monsterSnap['name']),
                      subtitle: Text('Power: ${monsterSnap['power']}'),
                      leading: Container(
                        width: 120,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(20),
                            right: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        child: Text(
                          monsterSnap['group'],
                          style: TextStyle(
                            color: backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              //! update
                              Navigator.pushNamed(context, 'update',
                                  arguments: {
                                    'name': monsterSnap['name'],
                                    'power': monsterSnap['power'].toString(),
                                    'group': monsterSnap['group'],
                                    'id': monsterSnap.id
                                  });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              //! delete
                              deleteMonster(monsterSnap.id);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // log(snapshot.error.toString());
            return Center(
              child: Text(
                'Some Error Occurred',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
