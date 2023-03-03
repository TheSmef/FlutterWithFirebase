import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseflutter/add.dart';
import 'package:firebaseflutter/cubit/data_cubit.dart';
import 'package:firebaseflutter/edit.dart';
import 'package:firebaseflutter/main.dart';
import 'package:firebaseflutter/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage()));
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
                                Text("id: ${snapshot.data?.elementAt(i).uid}",
                                    style: const TextStyle(fontSize: 18)),
                                Text(
                                    "Имя: ${snapshot.data?.elementAt(i).content}",
                                    style: const TextStyle(fontSize: 18)),
                                Text(
                                    "Дата создания: ${snapshot.data?.elementAt(i).date}",
                                    style: const TextStyle(fontSize: 18)),
                                SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final String? uid =
                                          snapshot.data?.elementAt(i).uid;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPage(uid: uid)));
                                    },
                                    child: const Text(
                                      'Изменить',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<DataCubit>().Delete(
                                          snapshot.data?.elementAt(i).uid);
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
}
