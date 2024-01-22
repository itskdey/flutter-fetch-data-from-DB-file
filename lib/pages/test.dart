import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
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
    return await _database.rawQuery('SELECT * FROM tb_categories');
  }

  @override
  Widget build(BuildContext context) {
    print("_data length: ${_data?.length}");

    return Scaffold(
      body: Container(
        child: _data == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _data!.length,
                itemBuilder: (context, index) {
                  if (index < _data!.length) {
                    final Meantitem = _data![index];

                    return GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Image.network(
                              Meantitem['icon'] ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return Text('Error loading image');
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              Meantitem['title'] ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    // Handle the case where _tData does not have an item at the current index
                    return Container();
                  }
                },
              ),
      ),
    );
  }
}
