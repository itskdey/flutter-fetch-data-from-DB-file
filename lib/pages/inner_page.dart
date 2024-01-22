import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();

  final int itemId;

  Test({required this.itemId});
}

class _TestState extends State<Test> {
  late Database _database;
  String? _htmlContent;
  String? _banner;
  String? _videos; // Add a variable to store the banner

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

    // Fetch HTML content and banner
    _htmlContent = await _fetchHtmlContent(widget.itemId);
    _banner = await _fetchBanner(widget.itemId);
    _videos = await _fetchVideo(widget.itemId);

    setState(() {});
  }

  Future<String?> _fetchHtmlContent(int itemId) async {
    final maps = await _database
        .rawQuery('SELECT content FROM tb_foods WHERE id = ?', [itemId]);
    if (maps.isNotEmpty) {
      return maps.first['content'] as String;
    }
    return null;
  }

  Future<String?> _fetchBanner(int itemId) async {
    final maps = await _database
        .rawQuery('SELECT banner FROM tb_foods WHERE id = ?', [itemId]);
    if (maps.isNotEmpty) {
      return maps.first['banner'] as String;
    }
    return null;
  }

  Future<String?> _fetchVideo(int itemId) async {
    final maps = await _database
        .rawQuery('SELECT videos FROM tb_foods WHERE id = ?', [itemId]);
    if (maps.isNotEmpty) {
      return maps.first['videos'] as String;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mean Pheakdey - Cooking App'),
      ),
      body: _htmlContent == null || _banner == null || _videos == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(_banner!), // Display the banner image
                  Html(data: _htmlContent),
                  Text(_videos!),
                ],
              ),
            ),
    );
  }
}
