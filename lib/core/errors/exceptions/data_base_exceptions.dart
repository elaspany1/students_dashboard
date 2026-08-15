abstract class DataBaseExceptions implements Exception {
  final String message;

  DataBaseExceptions({required this.message});
}

class SubabaseDatabaseExceptions extends DataBaseExceptions {
  SubabaseDatabaseExceptions({required super.message});
}
