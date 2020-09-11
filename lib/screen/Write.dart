import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sq2_flutter/data/memo.dart';
import 'package:sq2_flutter/data/sqldb.dart';
import 'package:crypto/crypto.dart';

class Write extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {
  String title = '';
  String text = '';
  String createTime = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Color(0xff003663),
            ),
            onPressed: () {},
          ),
          IconButton(
            color: Color(0xff003663),
            icon: const Icon(Icons.save),
            onPressed: saveDB,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (String title) {
                this.title = title;
              },
              style: GoogleFonts.yeonSung(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              maxLength: 30,
              decoration: InputDecoration(hintText: '할일의 제목', counterText: ""),
            ),
            Padding(padding: EdgeInsets.all(15)),
            TextField(
              onChanged: (String text) {
                this.text = text;
              },
              style: GoogleFonts.yeonSung(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              decoration:
                  InputDecoration(hintText: '내용을 적어주세요', counterText: ""),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    SqlDB sdb = SqlDB();

    var fido = Memo(
      id: strsha512(DateTime.now().toString()),
      text: this.text,
      title: this.title,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
    );

    await sdb.insertMeme(fido);
    Navigator.pop(context);
  }

  String strsha512(String text) {
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}
