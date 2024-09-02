import 'package:calendar/components/my_card_builder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends StatefulWidget {
  final String? option;

  const SearchPage({super.key, this.option});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _searchResults = [];
  String? _currentUserId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.option);
    _getCurrentUserId();
  }

  void _getCurrentUserId() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      _currentUserId = user?.uid;
    });
  }

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty || _currentUserId == null) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    print('Current User ID: $_currentUserId');
    List<String> keywords = keyword.split(' ');

    List<Map<String, dynamic>> results = [];

    for (String word in keywords) {
      print('Searching for keyword: $word');
      final snapshot = await FirebaseFirestore.instance
          .collection('Events')
          .where('EventTitle', isGreaterThanOrEqualTo: word)
          .where('EventTitle', isLessThanOrEqualTo: '$word\uf8ff')
          .get();

      print('Found ${snapshot.docs.length} results');
      results.addAll(snapshot.docs.map((doc) => doc.data()).toList());
    }

    final filteredResults = results.where((result) => result['ID'] == _currentUserId).toList();

    // Remove duplicates
    // final uniqueResults = results.toSet().toList();

    setState(() {
      _searchResults = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          "Search",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _search(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Using Your Event Title ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: CardBuilder(
                    title: result['EventTitle'],
                    description: result['EventDescription'],
                    date: result["Date"],
                    showDeleteIcon: false,
                    showEditIcon: false,
                    notesExist: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
