import 'package:isar/isar.dart';

part 'local_session_collection.g.dart';

@collection
class LocalSessionEntity {
  Id id = 0;
  String? currentUsername;
  int dataVersion = 1;
  DateTime updatedAt = DateTime.now();
}
