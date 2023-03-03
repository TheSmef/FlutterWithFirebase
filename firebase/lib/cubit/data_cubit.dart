import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../record.dart';

part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(InitialState());
  Future<List<Record>> getRecords() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("records").get();
    List<Record> records = <Record>[];
    for (var value in snapshot.docs) {
      Record record = Record(
          uid: value.id,
          content: value.get("content"),
          date: value.get("date"));
      records.add(record);
    }
    emit(SuccessState());
    return records;
  }

  Future<void> Delete(String? uid) async {
    if (uid != null) {
      FirebaseFirestore.instance.collection("records").doc(uid).delete();
      emit(SuccessState());
    }
  }
}
