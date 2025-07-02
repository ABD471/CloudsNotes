// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_single_cascade_in_expression_statements

import 'package:animations/animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Components/loading.dart';
import 'package:untitled/Notes/WriteNotes.dart';

import '../Getx/Controller.dart';
import 'Edit.dart';

class NoteView extends StatefulWidget {
  final String Iddoc;

  NoteView({required this.Iddoc});
  @override
  State<NoteView> createState() {
    return _noteView();
  }
}

class _noteView extends State<NoteView> {
  final ViewNotesController _viewNotesController = Get.put(
    ViewNotesController(),
  );

  late int indexDoc;

  @override
  void initState() {
    _viewNotesController.idDoc.value = widget.Iddoc;
    _viewNotesController.getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.add_circle, size: 70, color: Colors.orange),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => Writenotes(
                    iswrrite: false,
                    oldName: "",
                    docId: widget.Iddoc,
                  ),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("Notes".tr),
        titleTextStyle: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      body: Obx(() {
        if (_viewNotesController.isLoading.value == true) {
          return loading();
        } else if (_viewNotesController.data.isEmpty) {
          return Center(child: Text("Empty".tr));
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return _viewNotesController.getData();
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),

              itemCount: _viewNotesController.data.length,
              itemBuilder: (context, index) {
                final currentNoteDoc = _viewNotesController.data[index];

                final currentNoteData =
                    currentNoteDoc.data() as Map<String, dynamic>;

                final String noteName =
                    currentNoteData['Note'] ?? 'لا يوجد اسم';
                final String notetitle =
                      currentNoteData["title"]?? " ";
                  

                final String noteId = currentNoteDoc.id;

                return OpenContainer(
                  openBuilder: (context, CloseContainer) {
                    return Center(
                      child: Edit(
                        oldNametitle:notetitle ,
                        Iddoc2: noteId,
                        Iddoc: widget.Iddoc,
                        oldName: noteName,
                      ),
                    );
                  },
                  closedBuilder: (context, OpenContainer()) {
                    return InkWell(
                      onTap: () {
                        OpenContainer();

                        indexDoc = index;
                      },
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.bottomSlide,
                          title: 'AwesamTitle'.tr,
                          desc: "Awesamdecs".tr,
                          btnOkText: "Delete".tr,

                          btnOkOnPress: () async {
                            await _viewNotesController.DeleteData(
                              widget.Iddoc,
                              _viewNotesController.data[index].id,
                            );
                          },
                        )..show();
                      },
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notetitle,
                                style: TextStyle(color: Colors.blueAccent,fontSize: 20),
                              ),
                              Text(
                                noteName,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      }),
    );
  }
}
