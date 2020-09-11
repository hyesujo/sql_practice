import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sq2_flutter/data/memo.dart';
import 'package:sq2_flutter/data/sqldb.dart';
import 'package:sq2_flutter/screen/Detail.dart';

class View extends StatefulWidget {
  final String id;

  View({
    this.id,
  });

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  String deletedId = '';

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.chevron_left),
            color: Color(0xff003663),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Color(0xffaeb6c9),
        elevation: 0.0,
        actions: [
          IconButton(
              icon: const Icon(Icons.delete),
              color: Color(0xff003663),
              onPressed: () {
                showAlertDialog();
              }),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => DetailPage(id: widget.id),
              ))
                  .then((value) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.edit),
            color: Color(0xff003663),
          ),
        ],
      ),
      body: Container(
        color: Color(0xffaeb6c9),
        padding: EdgeInsets.all(8.0),
        child: LoadBuilder(),
      ),
    );
  }

  Future<List<Memo>> loadMemo(String id) {
    SqlDB sdb = SqlDB();
    return sdb.findMemo(id);
  }

  Widget LoadBuilder() {
    return FutureBuilder(
        future: loadMemo(widget.id),
        builder: (BuildContext context, AsyncSnapshot<List<Memo>> snaps) {
          if (!snaps.hasData)
            return Container(
              alignment: Alignment.center,
              child: Text('데이터를 불러올 수가 없어요'),
            );
          else {
            Memo memo = snaps.data[0];
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Text(
                    memo.title,
                    style: GoogleFonts.yeonSung(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 50),
                  width: double.infinity,
                  child: Text(
                    memo.text,
                    style: GoogleFonts.yeonSung(
                      fontSize: 21,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 200, right: 20),
                  width: double.infinity,
                  child: Text(
                    memo.createTime.split('.')[0],
                    style: GoogleFonts.yeonSung(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }

  Future<void> deleteMemo(String id) async {
    SqlDB sdb = SqlDB();
    await sdb.deleteMemo(id);
  }

  void showAlertDialog() async {
    await showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('삭제창'),
            content: Text('삭제하실건가요?'),
            actions: <Widget>[
              FlatButton(
                child: Text('삭제'),
                onPressed: () {
                  Navigator.pop(context, '삭제');
                  setState(() {
                    deleteMemo(widget.id);
                  });
                  Navigator.pop(_context);
                },
              ),
              FlatButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.pop(context, '취소');
                  }),
            ],
          );
        });
  }
}
