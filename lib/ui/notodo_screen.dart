// ignore_for_file: avoid_print

import "package:flutter/material.dart";
import 'package:notodo_app/model/nodo_item.dart';
import 'package:notodo_app/util/database_client.dart';

import '../util/date_formatter.dart';

class NoToDoScreen extends StatefulWidget {
  const NoToDoScreen({super.key});

  @override
  State<NoToDoScreen> createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();
  static int id = 0;

  final List<NoDoItem> _itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();
  }

  void _handleSubmitted(String text) async {
    _textEditingController.clear();
    id++;
    NoDoItem noDoItem = NoDoItem(id, text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);

    NoDoItem? addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem!);
    });

    print("Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: _itemList[index],
                      onLongPress: () => _udateItem(_itemList[index], index),
                      trailing: Listener(
                        key: Key(_itemList[index].itemName),
                        child: const Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteNoDo(_itemList[index].id, index),
                      ),
                    ),
                  );
                }),
          ),
          const Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          onPressed: _showFormDialog,
          child: const ListTile(
            title: Icon(Icons.add),
          )),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save")),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(NoDoItem.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteNoDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _udateItem(NoDoItem item, int index) {
    var alert = AlertDialog(
      title: const Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: "Item",
                hintText: "eg. Don't buy stuff",
                icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () async {
              NoDoItem newItemUpdated = NoDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateItem(newItemUpdated); //updating the item
              setState(() {
                _readNoDoList(); // redrawing the screen with all items saved in the db
              });

              Navigator.pop(context);
            },
            child: const Text("Update")),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
        return true;
      });
    });
  }
}
