import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_storage/view/seach_filter_note.dart';
import 'package:hexcolor/hexcolor.dart';

import '../database/connection_db.dart';
import '../model/note_model.dart';
import '../widget/form_widget.dart';
import '../widget/list_colors.dart';

class AddEditNoteScreen extends StatefulWidget {
  AddEditNoteScreen({super.key, required this.isAdd, this.note});
  NoteModel? note;
  bool isAdd;

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final List<String> listColors = ColorsData().getColorsNote;
  late String selectColor = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  DateTime? dateTime;

  // DropDown Data
  final List<String> items = [
    'Personal',
    'Development',
    'R&D',
    'School',
    'Work',
    'Partime',
    'Media',
    'More',
  ];
  String? selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectColor = listColors.first;
    if (!widget.isAdd) {
      titleController = TextEditingController(text: widget.note!.title);
      bodyController = TextEditingController(text: widget.note!.body);
      selectColor = widget.note!.colors.toString();
      selectedValue = widget.note!.category.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAdd ? 'New Note' : 'Edit Note'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFormWidget(
            controller: titleController,
            hindText: 'Title',
            textColor: HexColor(selectColor),
          ),
          TextFormWidget(
            controller: bodyController,
            hindText: 'Description',
            maxLine: 4,
            textColor: HexColor(selectColor),
          ),
          //DropDown

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Row(
                      children: [
                        Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 6, color: HexColor(selectColor)),
                          ),
                        ),
                        // Icon(
                        //   Icons.list,
                        //   size: 16,
                        //   color: Colors.black,
                        // ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Choose one',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(selectColor),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 200,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: Colors.white,
                      ),
                      elevation: 1,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: HexColor(selectColor),
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all(6),
                        thumbVisibility: WidgetStateProperty.all(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Colors
          Wrap(
            children: List.generate(
              listColors.length,
              (index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectColor = listColors[index];
                    });
                  },
                  child: CircleAvatar(
                    maxRadius: 18,
                    minRadius: 10,
                    backgroundColor: HexColor(
                      listColors[index].toString(),
                    ),
                    child: listColors[index] == selectColor
                        ? Center(
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 40),
        child: InkWell(
          onTap: () async {
            if (titleController.text.isNotEmpty &&
                bodyController.text.isNotEmpty &&
                selectedValue!.isNotEmpty) {
              if (widget.isAdd) {
                await ConnectionDb()
                    .insertNote(
                        note: NoteModel(
                            title: titleController.text,
                            body: bodyController.text,
                            dateTime: dateTime,
                            colors: selectColor,
                            category: selectedValue))
                    .whenComplete(
                  () {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                );
              } else {
                await ConnectionDb()
                    .updateNote(
                      note: NoteModel(
                          id: widget.note!.id,
                          title: titleController.text,
                          body: bodyController.text,
                          dateTime: dateTime,
                          colors: selectColor,
                          category: selectedValue),
                    )
                    .whenComplete(
                      // ignore: use_build_context_synchronously
                      () => Navigator.pop(context),
                    );
              }
            } else {
              print('Data Field is Empty..');
            }
          },
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: HexColor(selectColor),
            ),
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
