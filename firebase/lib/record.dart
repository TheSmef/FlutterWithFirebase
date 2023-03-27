import 'package:freezed_annotation/freezed_annotation.dart';

part 'record.freezed.dart';
part 'record.g.dart';

@freezed
class Record with _$Record {
  const factory Record({
    @JsonKey(ignore: true)
    String? uid,
    required String userid,
    required String name,
    required String uri,
    required int size,
  }) = _Record;

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
}
