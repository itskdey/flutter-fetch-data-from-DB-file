import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'inner_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class TypedFood extends StatefulWidget {
  final int typeID;

  TypedFood({required this.typeID});

  @override
  _TypedFoodState createState() => _TypedFoodState(typeID: typeID);
}

class _TypedFoodState extends State<TypedFood> {
  late final int typeID;
  late Database _database;
  List<Map<String, dynamic>>? _data;
  List<Map<String, dynamic>>? _typedFoods;

  _TypedFoodState({required this.typeID});

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocDir.path, 'food_recipe.db');

    if (!await databaseExists(dbPath)) {
      final byteData = await rootBundle.load('assets/food_recipe.db');
      final buffer = byteData.buffer.asUint8List();
      await File(dbPath).writeAsBytes(buffer);
    }

    _database = await openDatabase(dbPath);

    // Fetch data during initialization
    _data = await _fetchData();
    _typedFoods = await _fetchTypedFoods(typeID);
    setState(() {}); // Update the UI
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await _database.rawQuery('SELECT * FROM tb_foods');
  }

  Future<List<Map<String, dynamic>>> _fetchTypedFoods(int typeID) async {
    return await _database.rawQuery(
        'SELECT id, name, banner FROM tb_foods WHERE type_id = ?', [typeID]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mean Pheakdey - Cooking App'),
      ),
      body: _typedFoods == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _typedFoods?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the Test page with the ID as a parameter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Test(
                            itemId: _typedFoods![index]['id']
                                as int), // Pass the ID
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Color.fromARGB(65, 0, 0, 0),
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: Color.fromARGB(65, 0, 0, 0),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              height: 100,
                              width: 170,
                              child: Image.network(
                                _typedFoods![index]['banner'] as String,
                                fit: BoxFit.cover, // Adjust the fit as needed
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  _typedFoods![index]['name'].replaceAll(
                                      RegExp(r'[a-zA-Z---]'), '') as String,
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
