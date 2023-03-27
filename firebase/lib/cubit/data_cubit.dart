import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../record.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(InitialState());
  Future<List<Record>> getRecords() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("images")
        .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<Record> records = <Record>[];
    for (var value in snapshot.docs) {
      Record record = Record(
          uid: value.id,
          userid: value.get("userid"),
          name: value.get("name"),
          size: value.get("size"),
          uri: value.get("uri"));
      records.add(record);
    }
    emit(SuccessState());
    return records;
  }

  Future<void> delete(String? uid, String? url) async {
    if (uid != null && url != null) {
      FirebaseFirestore.instance.collection("images").doc(uid).delete();
      await FirebaseStorage.instance.refFromURL(url).delete();
      emit(SuccessState());
    }
  }
}
