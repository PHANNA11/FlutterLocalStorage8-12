import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_storage/database/connection_db.dart';
import 'package:flutter_local_storage/model/note_model.dart';
import 'package:flutter_local_storage/view/add_edit_note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'seach_filter_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> listNotes = [];
  void getData() async {
    await ConnectionDb().getNotes().then(
      (value) {
        setState(() {
          listNotes = value;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('App Note'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFilterNoteScreen(),
                )),
            icon: Icon(
              Icons.search,
              color: (Colors.black),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: listNotes.isEmpty
          ? Center(
              child: Image(
                  height: 100,
                  image: AssetImage('assets/images/empty_note.jpg')),
            )
          : ListView.builder(
              itemCount: listNotes.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditNoteScreen(
                                isAdd: false,
                                note: listNotes[index],
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.edit_document,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text(listNotes[index].title.toString()),
                                content:
                                    Text('Do you want to delete this note?'),
                                actions: [
                                  CupertinoButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  CupertinoButton(
                                      child: Text(
                                        'Okay',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () async {
                                        await ConnectionDb()
                                            .deleteNote(
                                                id: listNotes[index].id!)
                                            .whenComplete(
                                          () {
                                            Navigator.pop(context);
                                            getData();
                                          },
                                        );
                                      })
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Container(
                    // margin: EdgeInsets.all(8),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listNotes[index].title.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            Text(
                              listNotes[index].body.toString(),
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              DateFormat.yMMMMd()
                                  .format(listNotes[index].dateTime!),
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                listNotes[index].category.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              CircleAvatar(
                                backgroundColor: HexColor(
                                    listNotes[index].colors.toString()),
                                maxRadius: 8,
                                minRadius: 8,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditNoteScreen(
                        isAdd: true,
                      )));
        },
      ),
    );
  }
}
