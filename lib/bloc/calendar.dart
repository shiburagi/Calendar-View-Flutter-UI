import 'dart:async';

class CalendarBloc {
  StreamController<DateTime> _streamController = StreamController<DateTime>();
  Stream<DateTime> stream;

  StreamController<DateTime> _monthStreamController =
      StreamController<DateTime>();
  Stream<DateTime> monthStream;

  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;

  DateTime _monthDateTime = DateTime.now();
  DateTime get monthDateTime => _monthDateTime;
  DateTime collapseDateTime;

  CalendarBloc() {
    stream = _streamController.stream.asBroadcastStream();
    monthStream = _monthStreamController.stream.asBroadcastStream();

    stream.listen((DateTime data) {
      _dateTime = data;
    });
    monthStream.listen((DateTime data) {
      _monthDateTime = data;
    });
    _monthStreamController.sink.add(DateTime.now());
  }

  void dispose() {
    _streamController.close();
    _monthStreamController.close();
  }

  void updateSelectedDate(DateTime dateTime) {
    _streamController.sink.add(dateTime);
  }

  void updateMonth(DateTime dateTime) {
    _monthStreamController.sink.add(dateTime);
  }
}
