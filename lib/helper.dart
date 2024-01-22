import 'package:flutter/material.dart';
import 'pages/inner_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:get/get.dart';

class DatabaseScreen extends StatefulWidget {
  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  late Database _database;
  List<Map<String, dynamic>>? _data;

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
    setState(() {}); // Update the UI
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await _database.rawQuery('SELECT * FROM tb_foods');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mean Pheakdey - Cooking App'),
      ),
      body: _data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _data!.length,
              itemBuilder: (context, index) {
                final item = _data![index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the Test page with the ID as a parameter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Test(itemId: item['id'] ?? 0), // Pass the ID
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
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Image.network(
                                  item['banner'] ?? '',
                                  fit: BoxFit.cover, // Adjust the fit as needed
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Text(item['name'] ?? ''),
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
