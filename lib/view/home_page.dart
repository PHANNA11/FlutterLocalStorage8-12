import 'package:flutter/material.dart';
import 'package:flutter_local_storage/database/connection_db.dart';
import 'package:flutter_local_storage/model/note_model.dart';
import 'package:intl/intl.dart';

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
      ),
      body: ListView.builder(
        itemCount: listNotes.length,
        itemBuilder: (context, index) => InkWell(
          onLongPress: () async {
            await ConnectionDb()
                .deleteNote(id: listNotes[index].id!)
                .whenComplete(
              () {
                getData();
              },
            );
          },
          child: Container(
            margin: EdgeInsets.all(8),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                      listNotes[index].body.toString(),
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
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
                        'Person(${listNotes[index].id})',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.red,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await ConnectionDb()
              .insertNote(
                  note: NoteModel(title: 'App FLutter', body: 'Test App'))
              .whenComplete(
            () {
              getData();
            },
          );
        },
      ),
    );
  }
}
