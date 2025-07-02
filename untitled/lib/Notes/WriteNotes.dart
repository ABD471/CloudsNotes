import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Components/CostumBottun.dart';
import 'package:untitled/Notes/ViewNotes.dart';
import '../Getx/Controller.dart';

// ignore: must_be_immutable
class Writenotes extends StatefulWidget {
  late String docId;
  late String? docsubId;
  final String oldName;
  final bool iswrrite;
  Writenotes({
    required this.docId,
    required this.oldName,
    required this.iswrrite,
    this.docsubId,
  });
  @override
  State<Writenotes> createState() {
    return _WriteNotes();
  }
}

class _WriteNotes extends State<Writenotes> {
  late ViewNotesController _controller;
  late TextEditingController _title;
  late TextEditingController notes;

  @override
  void initState() {
    _controller = Get.put(ViewNotesController());
    _title = TextEditingController();
    notes = TextEditingController(text: widget.oldName);
    super.initState();
  }

  @override
  void dispose() {
    notes.dispose();
    _title.dispose();
    _controller.dispose();
    super.dispose();
  }

  CreateNotes() async {
    CollectionReference notescoll = await FirebaseFirestore.instance
        .collection('Category')
        .doc(widget.docId)
        .collection("Note");
    // Call the user's CollectionReference to add a new user
    await notescoll.add({
      "title": _title.text,
      "Note": notes.text,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
    _controller.getData();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NoteView(Iddoc: widget.docId)),
    );
  }

  EditeNotes() async {
    CollectionReference notescoll = await FirebaseFirestore.instance
        .collection('Category')
        .doc(widget.docId)
        .collection("Note");
    // Call the user's CollectionReference to add a new user
    await notescoll.doc(widget.docsubId).update({"Note": notes.text});
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NoteView(Iddoc: widget.docId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CostumBottoun(
        Title: "Create".tr,
        onPressed: () {
          if (widget.iswrrite == false  && notes.text.isNotEmpty){
            CreateNotes();
          } else if (widget.iswrrite == true && notes.text.isNotEmpty) {
            EditeNotes();
          }

          Navigator.of(context).pop();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Create Notes".tr),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: _title,
              decoration: InputDecoration(hintText: "title".tr),
            ),
            Expanded(
              child: TextFormField(
                controller: notes,
                minLines: null,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: widget.oldName,
                  border: InputBorder.none,
                //  filled: true,
                //  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
