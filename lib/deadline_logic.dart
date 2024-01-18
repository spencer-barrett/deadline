import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Deadline {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;

//Creates a new deadline
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

//Gets all Deadlines already created
  Future<List<List>> getDeadlines() async {
    QuerySnapshot qs = await db
        .collection('users')
        .doc(currentUser?.uid)
        .collection('Deadline')
        .get();
    final allData = qs.docs.map((doc) => doc.data()).toList();
    List<List> tmp = [];

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
      contents.add(split[2]);
      contents.add(split[1]);
      tmp.add(contents);
    }
    return tmp;
  }

// Function to delete any specific deadline
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

// Get most recent deadline
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

    collection = qs.docs.first.data();
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
  }
}
