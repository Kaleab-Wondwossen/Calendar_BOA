import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _firestore.collection("users").doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email},
          SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signout() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Generate a unique 4-digit random number
      String verificationCode =
          await generateUniqueRandomNumber(userCredential.user!.uid);

      // Store the concatenated ID in the user's collection in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'verificationCode': verificationCode,
        'role':"none" 
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception("this is the error ${e.code}");
    }
  }

  Future<String> generateUniqueRandomNumber(String userId) async {
    Random random = Random();
    int randomNumber;
    String verificationCode;
    bool isUnique = false;

    do {
      // Generate a random 4-digit number
      randomNumber = random.nextInt(9000) + 1000; // Range: 1000 - 9999

      // Concatenate the random number with the user's UID
      verificationCode = 'ID-$randomNumber';

      // Check if the concatenated ID already exists in Firestore
      var snapshot = await _firestore
          .collection('users')
          .where('verificationCode', isEqualTo: verificationCode)
          .get();

      // If no document with the generated ID exists, mark it as unique
      if (snapshot.docs.isEmpty) {
        isUnique = true;
      }
    } while (!isUnique);

    return verificationCode;
  }
}
