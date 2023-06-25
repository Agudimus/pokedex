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

  void showAboutPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return AboutPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Pokedex App'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Tambah Data'),
              onTap: () {
                Navigator.pushNamed(context, 'add');
              },
            ),
            ListTile(
              title: Text('Tentang Aplikasi'),
              onTap: () {
                showAboutPage();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/pokemon-logo-png-1446.png',
                      width: 98,
                      height: 98,
                    ),
                    Text(
                      'Aplikasi ini, dibuat oleh \n AGUDIMUS B DEMIH  (NIM 1754109),\n Untuk memenuhi mata kuliah Framework Mobile. Tujuannya adalah memberikan pengalaman praktis dalam pengembangan aplikasi mobile menggunakan  framework flutter',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
