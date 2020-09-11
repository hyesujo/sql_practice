import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sq2_flutter/data/memo.dart';
import 'package:sq2_flutter/data/sqldb.dart';
import 'package:sq2_flutter/screen/Write.dart';
import 'package:sq2_flutter/screen/view.dart';

class TodayMemo extends StatefulWidget {
  String title;

  TodayMemo({
    this.title,
  });
  @override
  _TodayMemoState createState() => _TodayMemoState();
}

class _TodayMemoState extends State<TodayMemo> {
  String deleteId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top:20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 30,
                  left: MediaQuery.of(context).size.width / 50,
                  bottom: 15),
              child: Text(
                '메모습관',
                style: GoogleFonts.yeonSung(
                  fontSize: 36,
                  color: Color(0xff003663),
                ),
              ),
            ),
            Expanded(
              child: memoBuilder(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => Write(),
          ))
              .then((value) {
            setState(() {});
          });
        },
        tooltip: '클릭하세요',
        label: Text(
          '메모추가',
          style: GoogleFonts.yeonSung(fontSize: 18),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget memoBuilder(BuildContext pcontext) {
    return FutureBuilder(
      future: loadMemo(),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> memosnap) {
        if (!memosnap.hasData) {
          return Container(
            child: Text('오늘 할일을 적어주세요'),
          );
        }
        return GridView.builder(
            itemCount: memosnap.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9),
            itemBuilder: (BuildContext context, int index) {
              Memo memo = memosnap.data[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => View(id: memo.id),
                  ))
                      .then((value) {
                    setState(() {});
                  });
                },
                onLongPress: () {
                  deleteId = memo.id;
                  showAlertDialog(pcontext);
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 5.5
                        ),
                          child: Text(
                            memo.title,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.yeonSung(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          memo.text,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.yeonSung(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '메모생성 시간' + '\n' + memo.createTime.split('.')[0],
                          style: GoogleFonts.yeonSung(
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffaeb6c9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Color(0xff9c9c8d), blurRadius: 3),
                      ]),
                ),
              );
            });
      },
    );
  }

  Future<List<Memo>> loadMemo() {
    SqlDB sdb = SqlDB();
    return sdb.memos();
  }

  Future<void> deleteMemo(String id) async {
    SqlDB sdb = SqlDB();
    await sdb.deleteMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('삭제'),
            content: Text('삭제할까요?'),
            actions: [
              FlatButton(
                child: Text('삭제'),
                onPressed: () {
                  Navigator.of(context).pop('삭제');
                  setState(() {
                    deleteMemo(deleteId);
                  });
                  deleteId = '';
                },
              ),
              FlatButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop('취소');
                },
              ),
            ],
          );
        });
  }
}
