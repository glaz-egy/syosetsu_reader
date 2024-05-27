import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syosetsu_reader/model/db_model.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseConnection extends AsyncNotifier<List<Map>> {
  late String path;
  late Database database;
  List<Book> books = [];
  List<String> ncodeList = [];

  @override
  Future<List<Map>> build() async {
    try {
      if (state.isLoading) {
        var databasesPath = await getDatabasesPath();
        debugPrint(databasesPath);
        path = '$databasesPath/bookshelf.db';
        database = await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Book (id INTEGER PRIMARY KEY AUTOINCREMENT, ncode TEXT, title TEXT, author TEXT, novel_type INTEGER, is_download TEXT, novel_create_date TEXT, novel_update_date TEXT, create_date TEXT, update_date TEXT)');
          await db.execute(
              'CREATE TABLE story (id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER, content TEXT, is_download INTEGER, create_date TEXT, update_date TEXT)');
          await db.execute(
              'CREATE TABLE Bookmark (id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER, story_num INTEGER, line_num INTEGER, create_date TEXT, update_date TEXT)');
        });
        debugPrint(database.isOpen.toString());
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> getBooks() async {
    if (!state.isLoading) {
      books.clear();
      ncodeList.clear();
      final List<Map<String, dynamic>> bookTable = await database.query('Book');
      for (var row in bookTable) {
        ncodeList.add(row['ncode']);
        books.add(Book(
            id: row['id'],
            ncode: row['ncode'],
            title: row['title'],
            author: row['author'],
            novelType: row['novel_type'],
            is_download: bool.parse(row['is_download']),
            novel_create_date: DateTime.parse(row['novel_create_date']),
            novel_update_date: DateTime.parse(row['novel_update_date']),
            create_date: DateTime.parse(row['create_date']),
            update_date: DateTime.parse(row['update_date'])));
      }
    }
  }

  Future<void> insertBook(Book book) async {
    ncodeList.add(book.ncode);
    await database.insert(
      'Book',
      {
        'title': book.title,
        'ncode': book.ncode,
        'author': book.author,
        'novel_type': book.novelType,
        'is_download': book.is_download.toString(),
        'novel_create_date': book.novel_create_date.toString(),
        'novel_update_date': book.novel_update_date.toString(),
        'create_date': book.create_date.toString(),
        'update_date': book.update_date.toString()
      },
    );
  }
}

final databaseConnectionProvider =
    AsyncNotifierProvider<DatabaseConnection, List<Map>>(() {
  return DatabaseConnection();
});
