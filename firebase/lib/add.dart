import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  _AddPageState();
  @override
  Widget build(BuildContext context) {
    final TextEditingController _contentController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              maxLength: 25,
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Содержание',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  addData(_contentController.text);
                },
                child: const Text(
                  'Добавить',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addData(String content) async {
    try {
      FirebaseFirestore.instance
          .collection("records")
          .add({"content": content, "date": DateTime.now().toString()}).then(
              (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainDataPage())));
    } catch (e) {}
  }
}
