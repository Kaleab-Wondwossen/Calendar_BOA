import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAds extends StatelessWidget {
  DeleteAds({super.key});

  final CollectionReference referenceFireStore =
      FirebaseFirestore.instance.collection("AdsList");

  Future<void> deleteImage(String docId, String imageUrl) async {
    try {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      // Delete document from Firestore
      await referenceFireStore.doc(docId).delete();

      print('Successfully deleted image and document.');
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ads List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: referenceFireStore.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final imageUrl = doc['image'];
              final name = doc['name'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  tileColor: Color.fromARGB(255, 245, 222, 174),
                  leading: Container(
                      height: 200,
                      width: 100,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )),
                  title: Text(
                    name,
                    style: GoogleFonts.acme(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteImage(doc.id, imageUrl);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
