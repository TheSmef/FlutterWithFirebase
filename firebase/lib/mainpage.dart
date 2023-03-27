import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseflutter/cubit/data_cubit.dart';
import 'package:firebaseflutter/main.dart';
import 'package:firebaseflutter/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainDataPage extends StatefulWidget {
  const MainDataPage({Key? key}) : super(key: key);

  @override
  State<MainDataPage> createState() => _MainDataPage();
}

class _MainDataPage extends State<MainDataPage> {
  late Future<List<Record>> notesList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                child: Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        const SizedBox(
          height: 30,
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () {
              insertImage();
            },
            child: const Text(
              'Добавить данные',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        BlocBuilder<DataCubit, DataState>(
          builder: (context, state) {
            return FutureBuilder(
                future: context.read<DataCubit>().getRecords(),
                builder: (context, snapshot) {
                  List<Widget> childrenVal = <Widget>[];
                  if (snapshot.hasData) {
                    childrenVal = <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < snapshot.data!.length; i++)
                            Column(
                              children: [
                                Text(
                                    "id: ${snapshot.data?.elementAt(i).userid}",
                                    style: const TextStyle(fontSize: 18)),
                                Image.network(
                                  snapshot.data!.elementAt(i).uri,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(error.toString());
                                  },
                                ),
                                Text(
                                    "Название: ${snapshot.data?.elementAt(i).name}",
                                    style: const TextStyle(fontSize: 18)),
                                Text(
                                    "Размер: ${snapshot.data?.elementAt(i).size}",
                                    style: const TextStyle(fontSize: 18)),
                                Text(
                                    "Ссылка: ${snapshot.data?.elementAt(i).uri}",
                                    style: const TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<DataCubit>().delete(
                                          snapshot.data?.elementAt(i).uid,
                                          snapshot.data?.elementAt(i).uri);
                                    },
                                    child: const Text(
                                      'Удалить',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ];
                  }
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: childrenVal,
                  ));
                });
          },
        ),
      ],
    ))));
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Future insertImage() async {
    // final result = await ImagePicker.platform.pickFiles(
    //   type: FileType.image,
    //   dialogTitle: 'Выбор файла',
    //   allowMultiple: false,
    // );
    final XFile? result =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      final size = await result.length();

      final file = await result.readAsBytes();

      final name = getRandomString(5);
      try {
        // UploadTask task =
        //     FirebaseStorage.instance.ref().child(result.name).putFile(file);
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        Reference ref = firebaseStorage.ref().child(name);
        UploadTask task = ref.putData(file);
        await task;
        task.then((data) async {
          var url = await data.ref.getDownloadURL();
          Record bulka = Record(
              userid: FirebaseAuth.instance.currentUser!.uid,
              name: result.name,
              uri: url,
              size: size);
          FirebaseFirestore.instance.collection("images").add(bulka.toJson());
        });
      } catch (e) {}
    } else {}
  }
}
