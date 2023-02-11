import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDoItem extends StatelessWidget {
  late int _id;
  String _itemName = "";
  String _dateCreated = "";

  NoDoItem(this._id, this._itemName, this._dateCreated, {super.key});

  NoDoItem.map(dynamic obj, {super.key}) {
    _id = obj["id"];
    _itemName = obj["itemName"];
    _dateCreated = obj["dateCreated"];
  }

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;

    // ignore: unnecessary_null_comparison
    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  NoDoItem.fromMap(Map<String, dynamic> map, {super.key}) {
    _id = map["id"];
    _itemName = map["itemName"];
    _dateCreated = map["dateCreated"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _itemName,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Created on: $_dateCreated",
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
