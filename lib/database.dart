import 'package:lecture/model%20.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String db_name = "Marketing tools";

var database;
loadDatabase() async {
  database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), '${db_name}_database.db'),

    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, categoryID INTEGER, categoryTitle TEXT, categoryImg TEXT )",
      );
      await db.execute(
        "CREATE TABLE proCategories(id INTEGER PRIMARY KEY, categoryID INTEGER, categoryTitle TEXT, categoryImg TEXT )",
      );
      await db.execute(
        "CREATE TABLE bookmarks(id INTEGER PRIMARY KEY, blogID INTEGER, title TEXT, content TEXT, img TEXT, categoryName TEXT, catID INTEGER )",
      );
      await db.execute(
        "CREATE TABLE tutorialsList(id INTEGER PRIMARY KEY, blogID INTEGER, title TEXT, content TEXT, img TEXT, categoryName TEXT, catID INTEGER )",
      );
      await db.execute(
        "CREATE TABLE programsList(id INTEGER PRIMARY KEY, blogID INTEGER, title TEXT, content TEXT )",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

Future<void> insertBookmark(getpostsModel blog) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'bookmarks',
    blog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertTutorialsList(getpostsModel blog) async {
  // Get a reference to the database.
  final Database db = await database;

  await db.insert(
    'tutorialsList',
    blog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertProgramsList(getpostsModel blog) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'programsList',
    blog.toProgramsMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertCategories(getCategorymodel blog) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'categories',
    blog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> insertProCategories(getCategorymodel blog) async {
  // Get a reference to the database.
  final Database db = await database;

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'proCategories',
    blog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<getpostsModel>> getBookmark() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('bookmarks');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return getpostsModel(
      id: maps[i]['blogID'],
      title: maps[i]['title'],
      img: maps[i]['img'],
      content: maps[i]['content'],
      categoryName: maps[i]['categoryName'],
    );
  });
}

Future<List<getpostsModel>> getTutorialsList(catID) async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps =
      await db.query('tutorialsList', where: "catID = ?", whereArgs: [catID]);
  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return getpostsModel(
      id: maps[i]['blogID'],
      title: maps[i]['title'],
      img: maps[i]['img'],
      content: maps[i]['content'],
      categoryName: maps[i]['categoryName'],
    );
  });
}

Future<List<getpostsModel>> getProgramsList() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('programsList');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return getpostsModel(
      id: maps[i]['blogID'],
      title: maps[i]['title'],
      content: maps[i]['content'],
    );
  });
}

Future<List<getCategorymodel>> getCategories() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('categories');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return getCategorymodel(
      id: maps[i]['categoryID'],
      name: maps[i]['categoryTitle'],
      img: maps[i]['categoryImg'],
    );
  });
}

Future<List<getCategorymodel>> getProCategories() async {
  // Get a reference to the database.
  final Database db = await database;

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('proCategories');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return getCategorymodel(
      id: maps[i]['categoryID'],
      name: maps[i]['categoryTitle'],
      img: maps[i]['categoryImg'],
    );
  });
}

findImage(id) async {
  final db = await database;
  var res = await db.query("bookmarks", where: "blogID = ?", whereArgs: [id]);

  return res.isNotEmpty ? true : false;
}

findTutorialsList(id) async {
  final db = await database;
  var res =
      await db.query("tutorialsList", where: "blogID = ?", whereArgs: [id]);

  return res.isNotEmpty ? true : false;
}

findProgramsList(id) async {
  final db = await database;
  var res =
      await db.query("programsList", where: "blogID = ?", whereArgs: [id]);

  return res.isNotEmpty ? true : false;
}

findCategory(id) async {
  final db = await database;
  var res =
      await db.query("categories", where: "categoryID = ?", whereArgs: [id]);

  return res.isNotEmpty ? true : false;
}

findProCategory(id) async {
  final db = await database;
  var res =
      await db.query("proCategories", where: "categoryID = ?", whereArgs: [id]);

  return res.isNotEmpty ? true : false;
}

Future<void> deleteCar(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'bookmarks',
    // Use a `where` clause to delete a specific dog.
    where: "blogID = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<void> deleteTutorialsList(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'tutorialsList',
    // Use a `where` clause to delete a specific dog.
    where: "blogID = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<void> deleteProgramsList(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'programsList',
    // Use a `where` clause to delete a specific dog.
    where: "blogID = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}

Future<void> deleteCategories(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'categories',
    // Use a `where` clause to delete a specific dog.
    where: "categoryID = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );

  print('Categories Deleted');
}

Future<void> deleteProCategories(int id) async {
  // Get a reference to the database.
  final db = await database;

  // Remove the Dog from the Database.
  await db.delete(
    'proCategories',
    // Use a `where` clause to delete a specific dog.
    where: "categoryID = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );

  print('Pro Categories Deleted');
}

// Now, use the method above to retrieve all the dogs.















































// import 'package:newfood/model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';


// String db_name = "learn_math";

// Future<Database> database;
// loadDatabase() async {
//   database = openDatabase(
//     join(await getDatabasesPath(), '${db_name}_database.db'),
//     onCreate: (db, version) async {
//       await db.execute(
//         "CREATE TABLE categories(id INTEGER PRIMARY KEY, categoryID INTEGER, categoryTitle TEXT, categoryImg TEXT )",
//       );
//       await db.execute(
//         "CREATE TABLE proCategories(id INTEGER PRIMARY KEY, categoryID INTEGER, categoryTitle TEXT, categoryImg TEXT )",
//       );
//       await db.execute(
//         "CREATE TABLE bookmarks(id INTEGER PRIMARY KEY, blogID INTEGER, title TEXT, content TEXT, image TEXT, categoryName TEXT, catID INTEGER )",
//       );
//       await db.execute(
//         "CREATE TABLE tutorialsList(id INTEGER PRIMARY KEY, blogID INTEGER, title TEXT, content TEXT, img TEXT, categoryName TEXT, catID INTEGER )",
//       );
//       await db.execute(
//         "CREATE TABLE programsList(id INTEGER PRIMARY KEY, blogID INTEGER, title TEXT, content TEXT )",
//       );
//     },
//     version: 1,
//   );
// }

// Future<void> insertBookmark(getpostsModel blog) async {
//   final Database db = await database;

//   await db.insert(
//     'bookmarks',
//     blog.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<void> insertTutorialsList(getpostsModel blog) async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Insert the Dog into the correct table. You might also specify the
//   // `conflictAlgorithm` to use in case the same dog is inserted twice.
//   //
//   // In this case, replace any previous data.
//   await db.insert(
//     'tutorialsList',
//     blog.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<void> insertProgramsList(getpostsModel blog) async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Insert the Dog into the correct table. You might also specify the
//   // `conflictAlgorithm` to use in case the same dog is inserted twice.
//   //
//   // In this case, replace any previous data.
//   await db.insert(
//     'programsList',
//     blog.toProgramsMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<void> insertCategories(getCategorymodel blog) async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Insert the Dog into the correct table. You might also specify the
//   // `conflictAlgorithm` to use in case the same dog is inserted twice.
//   //
//   // In this case, replace any previous data.
//   await db.insert(
//     'categories',
//     blog.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<void> insertProCategories(getCategorymodel blog) async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Insert the Dog into the correct table. You might also specify the
//   // `conflictAlgorithm` to use in case the same dog is inserted twice.
//   //
//   // In this case, replace any previous data.
//   await db.insert(
//     'proCategories',
//     blog.toMap(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<List<getpostsModel>> getBookmark() async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Query the table for all The Dogs.
//   final List<Map<String, dynamic>> maps = await db.query('bookmarks');

//   // Convert the List<Map<String, dynamic> into a List<Dog>.
//   return List.generate(maps.length, (i) {
//     return getpostsModel(
//       id: maps[i]['blogID'],
//       title: maps[i]['title'],
//       content: maps[i]['content'],
//     );
//   });
// }

// Future<List<getpostsModel>> getTutorialsList(catID) async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Query the table for all The Dogs.
//   final List<Map<String, dynamic>> maps =
//       await db.query('tutorialsList', where: "catID = ?", whereArgs: [catID]);
//   // Convert the List<Map<String, dynamic> into a List<Dog>.
//   return List.generate(maps.length, (i) {
//     return getpostsModel(
//       id: maps[i]['blogID'],
//       title: maps[i]['title'],
//       content: maps[i]['content'],
//     );
//   });
// }

// Future<List<getpostsModel>> getProgramsList() async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Query the table for all The Dogs.
//   final List<Map<String, dynamic>> maps = await db.query('programsList');

//   // Convert the List<Map<String, dynamic> into a List<Dog>.
//   return List.generate(maps.length, (i) {
//     return getpostsModel(
//       id: maps[i]['blogID'],
//       title: maps[i]['title'],
//       content: maps[i]['content'],
//     );
//   });
// }

// // Future<List<homepstsModel>> getCategories() async {
// //   // Get a reference to the database.
// //   final Database db = await database;

// //   // Query the table for all The Dogs.
// //   final List<Map<String, dynamic>> maps = await db.query('categories');

// //   // Convert the List<Map<String, dynamic> into a List<Dog>.
// //   return List.generate(maps.length, (i) {
// //     return homeModel(
// //       id: maps[i]['categoryID'],
// //       name: maps[i]['categoryTitle'],
// //       img: maps[i]['categoryImg'],
// //     );
// //   });
// // }

// Future<List<getCategorymodel>> getProCategories() async {
//   // Get a reference to the database.
//   final Database db = await database;

//   // Query the table for all The Dogs.
//   final List<Map<String, dynamic>> maps = await db.query('proCategories');

//   // Convert the List<Map<String, dynamic> into a List<Dog>.
//   return List.generate(maps.length, (i) {
//     return getCategorymodel(
//       id: maps[i]['categoryID'],
//       name: maps[i]['categoryTitle'],
//       img: maps[i]['categoryImg'],
//     );
//   });
// }

// findImage(id) async {
//   final db = await database;
//   var res = await db.query("bookmarks", where: "blogID = ?", whereArgs: [id]);

//   return res.isNotEmpty ? true : false;
// }

// findTutorialsList(id) async {
//   final db = await database;
//   var res =
//       await db.query("tutorialsList", where: "blogID = ?", whereArgs: [id]);

//   return res.isNotEmpty ? true : false;
// }

// findProgramsList(id) async {
//   final db = await database;
//   var res =
//       await db.query("programsList", where: "blogID = ?", whereArgs: [id]);

//   return res.isNotEmpty ? true : false;
// }

// findCategory(id) async {
//   final db = await database;
//   var res =
//       await db.query("categories", where: "categoryID = ?", whereArgs: [id]);

//   return res.isNotEmpty ? true : false;
// }

// Future<void> deleteCar(int id) async {
//   // Get a reference to the database.
//   final db = await database;

//   // Remove the Dog from the Database.
//   await db.delete(
//     'bookmarks',
//     // Use a `where` clause to delete a specific dog.
//     where: "blogID = ?",
//     // Pass the Dog's id as a whereArg to prevent SQL injection.
//     whereArgs: [id],
//   );
// }
