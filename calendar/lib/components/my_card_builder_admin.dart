import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/FireStore/fire_store.dart';

class CardBuilderAdmin extends StatelessWidget {
  const CardBuilderAdmin({
    super.key,
    required this.title,
    required this.description,
    this.color,
    this.docId,
    this.date,
    this.showEditIcon = true,
    this.showDeleteIcon = true,
  });

  final String title;
  final String description;
  final Color? color;
  final String? docId;
  final String? date;
  final bool showEditIcon;
  final bool showDeleteIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color ?? const Color.fromARGB(255, 245, 222, 174),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          description,
                          style: GoogleFonts.inter(),
                          softWrap: true,
                        ),
                      ),
                      Text(date.toString()),
                    ],
                  ),
                ],
              ),
              if (showEditIcon)
                IconButton(
                  onPressed: () {
                    final TextEditingController titleController =
                        TextEditingController(text: title);
                    final TextEditingController descriptionController =
                        TextEditingController(text: description);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Edit Event',
                            style: GoogleFonts.acme(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleController,
                                decoration:
                                    const InputDecoration(labelText: 'Title'),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                    labelText: 'Description'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.acme(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                String newTitle = titleController.text;
                                String newDescription =
                                    descriptionController.text;
                                FireStoreServices editService =
                                    FireStoreServices();
                                editService.updateNoteAdmin(
                                    docId!, newTitle, newDescription);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Submit',
                                style: GoogleFonts.acme(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              if (showDeleteIcon)
                IconButton(
                  onPressed: () {
                    FireStoreServices deleteService = FireStoreServices();
                    deleteService.deleteNoteAdmin(docId!);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 252, 17, 0),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
