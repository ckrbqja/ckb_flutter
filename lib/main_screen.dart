import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController introduceController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    getIntroduceData();
  }

  @override
  Widget build(BuildContext context) {
    Container container({required String name, required String text}) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 150,
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              text,
            ),
          ],
        ),
      );
    }

    var a = [];
    for (Map<String, String> element in [
      {'name': '이름', 'text': '이홍철'},
      {'name': '나이', 'text': '30'},
      {'name': '취미', 'text': '컴퓨터 게임'},
      {'name': '직업', 'text': '프로그래머'},
      {'name': '학력', 'text': '부천 대학 졸업'},
      {'name': '이름', 'text': '이홍철'},
    ]) {
      var name = element['name'] as String;
      var text = element['text'] as String;

      a.add(container(name: name, text: text));
    }
    //
    // print(a);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(
          Icons.accessibility_new,
          size: 32,
        ),
        title: Text(
          "발전하는 개발자 차규범을 소개합니다",
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/business-card.png',
                    fit: BoxFit.cover,
                  ),
                )),
            //이름 섹션
            ...a,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    '자기소개',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (introduceController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("자기소개가 비어있음"),
                        duration: Duration(seconds: 2),
                      ));

                      return;
                    }

                    var sharedPref = await SharedPreferences.getInstance();
                    sharedPref.setString('introduce', introduceController.text);

                    setState(() => isEdit = !isEdit);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16, top: 16),
                    child: Icon(
                      Icons.edit,
                      color: isEdit ? Colors.blueAccent : Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                maxLines: 5,
                controller: introduceController,
                enabled: isEdit,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffd9d9d9)))),
              ),
            ),
          ],
        ),
        //이름섹션
      ),
    );
  }

  Future<void> getIntroduceData() async {
    var instance = await SharedPreferences.getInstance();
    introduceController.text = instance.getString('introduce').toString() ?? "";
  }
}
