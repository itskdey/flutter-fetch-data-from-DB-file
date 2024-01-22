// import 'package:flutter/material.dart';

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:io';
// import 'package:flutter_html/flutter_html.dart';

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();

//   final int itemId;

//   Test({required this.itemId});
// }

// class _TestState extends State<Test> {
//   late Database _database;
//   Map<String, dynamic>? _item;

//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//   }

//   Future<void> _initDatabase() async {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final dbPath = join(appDocDir.path, 'food_recipe.db');

//     if (!await databaseExists(dbPath)) {
//       final byteData = await rootBundle.load('assets/food_recipe.db');
//       final buffer = byteData.buffer.asUint8List();
//       await File(dbPath).writeAsBytes(buffer);
//     }

//     _database = await openDatabase(dbPath);

//     _item = await _fetchItem(widget.itemId);
//     setState(() {});
//   }

//   Future<Map<String, dynamic>?> _fetchItem(int itemId) async {
//     final maps = await _database
//         .rawQuery('SELECT * FROM tb_foods WHERE id = ?', [itemId]);
//     if (maps.isNotEmpty) {
//       return maps.first;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mean Pheakdey - Cooking App'),
//       ),
//       body: _item == null
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SizedBox(
//               width: double.infinity,
//               height: 1000,
//               child: Html(_item?['content'] ?? ''),
//             ),
//     );
//   }
// }


// what's wrong