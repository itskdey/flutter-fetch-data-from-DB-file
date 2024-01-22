import 'package:flutter/material.dart';
import 'typed_Food.dart';
import 'meatFood.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Database _database;
  List<Map<String, dynamic>>? _data;
  List<Map<String, dynamic>>? _tData;
  List<Map<String, dynamic>>? _fData;
  List<Map<String, dynamic>>? _bData;

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
    _tData = await _fetchFood();
    _fData = await _fetchAllFood();
    setState(() {}); // Update the UI
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    return await _database.rawQuery('SELECT * FROM tb_categories');
  }

  Future<List<Map<String, dynamic>>> _fetchFood() async {
    return await _database.rawQuery('SELECT * FROM tb_types');
  }

  Future<List<Map<String, dynamic>>> _fetchBannerFood() async {
    return await _database.rawQuery('SELECT id FROM tb_types WHERE ');
  }

  Future<List<Map<String, dynamic>>> _fetchAllFood() async {
    return await _database.rawQuery('SELECT * FROM tb_foods');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mean Pheakdey - Cooking App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Add your onPressed function here
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "ប្រភេទមុខម្ហូប",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 170, // Set the desired height for items
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tData?.length,
              itemBuilder: (context, index) {
                final item = _tData![index];

                // final Mitem = _data![index];
                final fItem = _fData![index];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      TypedFood(typeID: item['id'] ?? 0),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          width: 200, // Set the height for each item
                          margin: const EdgeInsets.all(5),
                          child: Image.network(
                            fItem['banner'] ?? 0,
                            fit: BoxFit
                                .cover, // Use BoxFit.cover to fill the container
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        // height: 30,
                        child: Center(
                          child: Text(
                            item['title']
                                    ?.replaceAll(RegExp(r'[a-zA-Z---]'), '') ??
                                '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              "ប្រភេទសាច់",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            // Wrap the second ListView.builder in an Expanded widget
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _data!.length,
                itemBuilder: (context, index) {
                  final Meantitem = _data![index];
                  final ddditem = _data![index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        MeatFood(meatID: ddditem['id'] ?? 0),
                      );
                    },
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
                            Meantitem['title']
                                    ?.replaceAll(RegExp(r'[a-zA-Z---]'), '') ??
                                '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
