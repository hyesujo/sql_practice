import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sq2_flutter/data/memo.dart';
import 'package:sq2_flutter/data/sqldb.dart';

class DetailPage extends StatefulWidget {
  final String id;

  DetailPage({
    this.id,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String title = '';
  String text = '';
  String createTime = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
            ),
            iconSize: 30,
            color: Color(0xff003663),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
            onPressed: upadateDB,
            icon: const Icon(
              Icons.save,
              color: Color(0xff003663),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: LoadBuilder(),
      ),
    );
  }

  Future<List<Memo>> loadMemo(String id) async {
    SqlDB sdb = SqlDB();
    return await sdb.findMemo(id);
  }

  Widget LoadBuilder() {
    return FutureBuilder(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snaps) {
        if (snaps.data == null || snaps.data == []) {
          return Container(
            child: Center(
              child: Text('데이터를 불러올 수 없습니다.'),
            ),
          );
        } else {
          Memo memo = snaps.data[0];

          var tecTitle = TextEditingController();
          title = memo.title;
          tecTitle.text = title;

          var tecText = TextEditingController();
          text = memo.text;
          tecText.text = text;

          createTime = memo.createTime;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: tecTitle,
                maxLines: 1,
                maxLength: 30,
                onChanged: (String title) {
                  this.title = title;
                },
                style: GoogleFonts.yeonSung(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: '할일의 제목',
                  counterText: "",
                ),
              ),
              Padding(padding: EdgeInsets.all(15)),
              TextField(
                controller: tecText,
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
          );
        }
      },
    );
  }

  void upadateDB() async {
    SqlDB sdb = SqlDB();

    var fido = Memo(
      id: widget.id,
      title: this.title,
      text: this.text,
      createTime: this.createTime,
      editTime: DateTime.now().toString(),
    );

    await sdb.updateMemo(fido);

    print(await sdb.memos());
    Navigator.pop(context);
  }
}
