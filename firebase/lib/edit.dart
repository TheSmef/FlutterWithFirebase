import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage({super.key, this.uid});

  late String? uid;

  @override
  State<EditPage> createState() => _EditPageState(uid: uid);
}

class _EditPageState extends State<EditPage> {
  _EditPageState({this.uid});
  late String? uid;
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
                  editData(_contentController.text, uid!);
                },
                child: const Text(
                  'Изменить',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editData(String content, String uid) async {
    try {
      FirebaseFirestore.instance
          .collection("records")
          .doc(uid)
          .set({"content": content, "date": DateTime.now().toString()}).then(
              (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainDataPage())));
    } catch (e) {}
  }
}
