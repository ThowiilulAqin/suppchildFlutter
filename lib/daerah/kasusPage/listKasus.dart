import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suppchild_ver_1/constant.dart';
import 'package:http/http.dart' as http;
import 'package:suppchild_ver_1/daerah/kasusPage/statusKasus.dart';
import 'package:suppchild_ver_1/main.dart';

class ListKasus extends StatefulWidget {
  @override
  _ListKasusState createState() => _ListKasusState();
}

class _ListKasusState extends State<ListKasus> {
  //Mengambil data kegiatan dari db
  Future<List> getDataKasus() async {
    final response =
        await http.get("http://suppchild.xyz/API/daerah/getKasus.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonTambah() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
        child: Center(
          child: Container(
            width: 380,
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/unggahKasus');
              },
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: colorMainPurple,
              child: Text(
                'Tambah Laporan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        buttonTambah(),
        Container(
          width: 380,
          child: Wrap(
            children: <Widget>[
              Container(
                width: 380,
                child: Container(
                  color: colorMainPurple,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        '$daerahuser',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FutureBuilder<List>(
                future: getDataKasus(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print("Error");

                  return snapshot.hasData
                      ? new SelectedList(
                          allList: snapshot.data,
                        )
                      : new Center();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectedList extends StatelessWidget {
  SelectedList({this.allList});
  final List allList;

  @override
  Widget build(BuildContext context) {
    List selectedList =
        allList.where((data) => data['daerah'] == 'Gresik').toList();

    Widget listKasus(i, kasus) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorMainPurple,
              width: 3,
            ),
            right: BorderSide(
              color: colorMainPurple,
              width: 3,
            ),
            bottom: BorderSide(
              color: colorMainPurple,
              width: 3,
            ),
          ),
        ),
        width: double.infinity,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatusKasus(
                    list: selectedList,
                    index: i - 1,
                  ),
                ));
          },
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                '$i. $kasus',
                style: TextStyle(
                  color: colorMainPurple,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: selectedList == null ? 0 : selectedList.length,
      itemBuilder: (context, i) {
        return listKasus(i + 1, selectedList[i]['nama']);
      },
    );
  }
}
