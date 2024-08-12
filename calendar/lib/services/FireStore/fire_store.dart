import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FireStoreServices {
  late CollectionReference notesDynamic;
  //get data from the 2firestore
  initializeDatabase(String name) {
    notesDynamic = FirebaseFirestore.instance.collection(name);
  }

  final firebaseMessageing = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await firebaseMessageing.requestPermission();
    final fcmToken = await firebaseMessageing.getToken();
    print("Token: ====================== ${fcmToken} =================");
  }

  final CollectionReference notes =
      FirebaseFirestore.instance.collection("Events");

  final CollectionReference Urls =
      FirebaseFirestore.instance.collection("AdsList");

  final CollectionReference adminNotes =
      FirebaseFirestore.instance.collection("AdminEvents");

  final CollectionReference notes2 =
      FirebaseFirestore.instance.collection("users");

  //Create: add note to the fire store
  Future<void> add(
      String title, String description, String date, String userId) {
    return notes.add({
      'EventTitle': title,
      'EventDescription': description,
      'ID': userId,
      "Date": date,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> addEvents(
      String title, String description, String date, String userId) {
    return adminNotes.add({
      'EventTitle': title,
      'EventDescription': description,
      'ID': userId,
      "Date": date,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> addDynaic(
      String venterId, String venterEmail, int price, String message) {
    return notesDynamic.add({
      "venterId": venterId,
      'venterEmail': venterEmail,
      'ventMessage': message,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> addTry(
    String imageName,
  ) {
    return notes.add({"note": imageName, 'timestamp': Timestamp.now()});
  }

  //Retrive: brings up note from the fire store
  Stream<QuerySnapshot> getNotes() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  Stream<QuerySnapshot> getImageUrl() {
    final imageUrl =
        Urls.orderBy('timestamp', descending: true).snapshots();
    return imageUrl;
  }

  Stream<QuerySnapshot> getUsers() {
    final notesStream =
        notes2.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  Stream<QuerySnapshot> getNotesDynamic() {
    final notesStream =
        notesDynamic.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //Update: edit notes with a provided doc id
  Future<void> updateNote(String docId, String title, String description) {
    return notes.doc(docId).update({
      'EventTitle': title,
      'EventDescription': description,
      'timestamp': Timestamp.now()
    });
  }

  //Update: edit notes with a provided doc id
  Future<void> updateNoteAdmin(String docId, String title, String description) {
    return adminNotes.doc(docId).update({
      'EventTitle': title,
      'EventDescription': description,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> updateNoteDynamic(
      String docId, String title, String description) {
    return notesDynamic.doc(docId).update({
      'EventTitle': title,
      'EventDescription': description,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> updateNoteTry(
    String docId,
    String imageName,
  ) {
    return notes.doc(docId).update({
      'note': imageName,
      // 'name': name,
      // 'price': price,
      // 'discription': description,
      // 'timestamp': Timestamp.now()
    });
  }

  //Delete: delete notes with a provided doc id
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }

  Future<void> deleteNoteAdmin(String docID) {
    return adminNotes.doc(docID).delete();
  }

  Future<void> deleteCollection() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Events');

    // Get all documents in the collection
    QuerySnapshot querySnapshot = await collectionReference.get();

    // Iterate through each document and delete it
    querySnapshot.docs.forEach((document) {
      document.reference.delete();
    });

    print('Collection deleted successfully.');
  }

  Future<void> deleteNoteDynamic(String docID) {
    return notesDynamic.doc(docID).delete();
  }

  Future<String?> searchUserUIDByEmail(String email) async {
    try {
      // Create a reference to the Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Query for documents where the email field matches the provided email
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();

      // Check if any documents were found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming emails are unique)
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        // Retrieve the UID from the document
        String? uid = userDoc.get(
            'verificationCode'); // Replace 'UID' with the actual field name in your Firestore document

        // Return the UID
        return uid;
      } else {
        // No matching document found
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error searching user UID by email: $e');
      return null;
    }
  }
}
