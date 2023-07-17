import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> searchInFirestore() async {
  final firestore = FirebaseFirestore.instance;

  // Build the query
  Query query = firestore.collection('posts');

  // Add the search conditions
  query = query.where('postText', isEqualTo: '안녕');
  query = query.where('postTitle', isEqualTo: '안녕');
  // Add more conditions as needed

  // Execute the query
  final QuerySnapshot querySnapshot = await query.get();

  // Access the documents
  final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  for (var document in documents) {
    // Access the fields in the document
    final field1Value = document.get('field1');
    final field2Value = document.get('field2');
    // Do something with the values
  }
}
