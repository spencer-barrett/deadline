import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Deadline {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  List recentList = [];
  int size = 0;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> createDeadline({
    required String title,
    required String dueDate,
    required String description,
  }) async {
    await db
        .collection('users')
        .doc(currentUser?.uid)
        .collection('Deadline')
        .doc(title)
        .set({
      'Title': title,
      'Due Date': dueDate,
      'Description': description,
      'Completed': false,
      'timestamp': Timestamp.now(),
    });
  }

  Future<List<List>> getDeadlines() async {
    QuerySnapshot qs = await db
        .collection('users')
        .doc(currentUser?.uid)
        .collection('Deadline')
        .get();
    final allData = qs.docs.map((doc) => doc.data()).toList();
    List<List> tmp = [];
    // List<List> tmpp = [];
    // print(allData[1]);
    // for (var key in allData) {
    //   tmp.add(key!);
    //   print(key);
    // }
    // print(allData.first);
    // print(allData);
    for (int i = 0; i < allData.length; i++) {
      final contents = <String>[];

      final split = allData[i].toString().split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      final splitFirstBracket = values[0].toString().split('{');
      final splitLastBracket = values[5].toString().split('}');
      contents.add(splitLastBracket[0]);
      contents.add(splitFirstBracket[1].toString());
      // contents.add(split[1]);
      contents.add(split[2]);
      contents.add(split[1]);
      tmp.add(contents);
    }
    // print(tmp);

    // print(tmp);

    return tmp;
  }

  Future<void> deleteDeadline({
    required String id,
  }) async {
    await db
        .collection('users')
        .doc(currentUser?.uid)
        .collection('Deadline')
        .doc(id)
        .delete();
  }

  Future<List> getRecentDeadline() async {
    Map<String, dynamic> collection;
    final contents = <String>[];

    QuerySnapshot<Map<String, dynamic>> qs = await db
        .collection('users')
        .doc(currentUser?.uid)
        .collection('Deadline')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    // final allData = qs.docs.map((doc) => doc.data()).toList();
    // final data = qs.docs.toList();

    collection = qs.docs.first.data();

    // String data = allData[0].toString();
    final split = collection.toString().split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    final splitFirstBracket = values[0].toString().split('{');
    final splitLastBracket = values[5].toString().split('}');
    contents.add(splitFirstBracket[1].toString());
    contents.add(split[1]);
    contents.add(split[2]);
    contents.add(splitLastBracket[0]);

    return contents;

    // print(collection.toString());
  }
}
