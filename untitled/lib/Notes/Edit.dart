// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Getx/Controller.dart';

class Edit extends StatefulWidget {
  final String? Iddoc;
  final String? Iddoc2;
  final String? oldName;
  final String? oldNametitle;


  const Edit({super.key, this.oldName, this.Iddoc, this.Iddoc2, this.oldNametitle});

  @override
  State<Edit> createState() {
    return _Edit();
  }
}

class _Edit extends State<Edit> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodetitle = FocusNode();
  bool? onTap = false;
  List<String> _history = [""];
  int _historyIndex = 0;

  late TextEditingController _title;
  late TextEditingController _text;
  late EditeNotesController _notesController;
  late ViewNotesController _viewNotesController;

  // ignore: unused_element

  @override
  void initState() {
    _viewNotesController = Get.find();
    _notesController = Get.put(EditeNotesController());

    _title = TextEditingController( text :widget.oldNametitle);
    _text = TextEditingController(text: widget.oldName);
    _text.addListener(onChngeText);
    _title.addListener(onChngeTitle);
    
    _focusNode.addListener(onFocusChange);
    _focusNodetitle.addListener(onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    //  _viewNotesController.dispose();
    // _notesController.dispose();
    _title.dispose();
    _text.removeListener(onChngeText);
    _text.dispose();
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() async {
    if (!_focusNode.hasFocus) {
      _notesController.onTap.value = false;

      await FirebaseFirestore.instance
          .collection('Category')
          .doc(widget.Iddoc)
          .collection("Note")
          .doc(widget.Iddoc2)
          .update({
            "title": _title.text,
            "Note": _text.text,
            "updatedAt": FieldValue.serverTimestamp(),
          });

      _viewNotesController.getData();
    } else {
      _notesController.onTap.value = true;
    }
  }

  void onChngeText() {
    if (_text.text != _history[_historyIndex]) {
      _history = _history.sublist(0, _historyIndex + 1);
      _history.add(_text.text);
      _historyIndex = _history.length - 1;
      setState(() {});
    }
  }

  void onChngeTitle() {
    if (_title.text != _history[_historyIndex]) {
      _history = _history.sublist(0, _historyIndex + 1);
      _history.add(_title.text);
      _historyIndex = _history.length - 1;
      setState(() {});
    }
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _text.text = _history[_historyIndex];
        _text.selection = TextSelection.fromPosition(
          TextPosition(offset: _text.text.length),
        );
      });
    }
  }

  void _redo() {
    if (_historyIndex < _history.length - 1) {
      setState(() {
        _historyIndex++;
        _text.text = _history[_historyIndex];
        _text.selection = TextSelection.fromPosition(
          TextPosition(offset: _text.text.length),
        );
      });
    }
  }

  void _Save(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('Category')
        .doc(widget.Iddoc)
        .collection("Note")
        .doc(widget.Iddoc2)
        .update({
          "title": _title.text,
          "Note": _text.text,
          "updatedAt": FieldValue.serverTimestamp(),
        });

    _viewNotesController.getData();
    _notesController.onTap.value = false;
    _focusNode.unfocus();
    Get.snackbar("Success".tr, "Text Saved".tr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(5),
        elevation: 5,

        actions: [
          Obx(() {
            if (_notesController.onTap.value == true) {
              return Row(
                children: [
                  
                  IconButton(
                    onPressed: () {
                      _Save(context);
                    },
                    icon: Icon(Icons.check_box_rounded),
                  ),
                  IconButton(
                    onPressed: _historyIndex > 0 ? _undo : null,
                    icon: Icon(Icons.undo_rounded),
                  ),
                  IconButton(
                    onPressed:
                        _historyIndex < _history.length - 1 ? _redo : null,
                    icon: Icon(Icons.redo_rounded),
                  ),
                ],
              );
            

            }
             else {
              return PopupMenuButton(
                enabled: true,
                onSelected: (value) async {
                  if (value == "Delete") {
                    await FirebaseFirestore.instance
                        .collection('Category')
                        .doc(widget.Iddoc)
                        .collection("Note")
                        .doc(widget.Iddoc2)
                        .delete();

                    _viewNotesController.getData();
                    Get.back();
                  }
                },
                itemBuilder:
                    (context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: "Delete",
                        child: Text("Delete".tr),
                      ),
                    ],
              );
            }
          }),
        ],
      ),

      body: Obx(() {
        final currentNoteDoc = _viewNotesController.data[0];

        final currentNoteData = currentNoteDoc.data() as Map<String, dynamic>;

        final Timestamp? noteDate = currentNoteData['updatedAt'] as Timestamp?;
        // ignore: unused_local_variable
        final String titlename = currentNoteData["title"] ?? "";

        return Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                focusNode: _focusNodetitle,
                maxLines: 1,
                controller: _title,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "title".tr,
                ),
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    "LastUpdated".tr,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    noteDate?.toDate().toString() ?? "",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "||",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Character count".tr,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _text.text.length.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Flexible(
                child: Container(
                  height: 5740,
                  child: TextFormField(
                    focusNode: _focusNode,

                    controller: _text,
                    minLines: null,
                    maxLines: null,
                    expands: true,
                    

                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(border: InputBorder.none),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
