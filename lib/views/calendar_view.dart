import 'dart:async';

import 'package:calendar_view/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infinite_view_pager/infinite_view_pager.dart';

class CalendarView extends StatefulWidget {
  final List<Event> events;
  final List<DateTime> selected;
  final bool collapseView;
  final Function onDateSelected;

  CalendarView(
      {this.events,
      this.onDateSelected,
      this.collapseView = false,
      this.selected = const [],
      Key key})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _dateTime = DateTime.now();
  StreamController<DateTime> _streamController = StreamController<DateTime>();
  Stream<DateTime> _stream;

  List<String> dateLabels;

  int get daysInMonth {
    return DateTime(_dateTime.year, _dateTime.month + 1, 1)
        .subtract(Duration(days: 1))
        .day;
  }

  int get firstDayOfMonth {
    return (DateTime(_dateTime.year, _dateTime.month, 1).weekday) % 7;
  }

  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    dateTime = dateTime.subtract(Duration(days: (dateTime.weekday)));
    DateFormat dateFormat = DateFormat.E();
    dateLabels = List.generate(
      7,
      (i) => dateFormat
          .format(
            dateTime.add(
              Duration(days: i),
            ),
          )
          .substring(0, 1),
    );

    _stream = _streamController.stream.asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String month = DateFormat("MMMM yyyy").format(_dateTime);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildMonthControll(month),
          SizedBox(
            height: 8,
          ),
          _buildDayHeader(),
          widget.collapseView ? _buildDayCollapseLayout() : _buildDayLayout(),
          SizedBox(height: 12)
        ],
      ),
    );
  }

  Container _buildDayHeader() {
    return Container(
      child: GridView.count(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 7,
        childAspectRatio: 1.3,
        children: List.generate(7, (i) {
          return _buildDate(dateLabels[i],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ));
        }),
      ),
    );
  }

  DateTime _collapseDateTime;
  Widget _buildDayCollapseLayout() {
    if (_collapseDateTime == null) {
      _collapseDateTime = DateTime.fromMillisecondsSinceEpoch(
          widget.selected[0].millisecondsSinceEpoch);

      _collapseDateTime = _collapseDateTime.subtract(Duration(
        days: _collapseDateTime.weekday,
      ));
    }
    return Container(
      height: 60,
      child: InfiniteViewPager(
        onPageChanged: (direction) {
          _collapseDateTime =
              _collapseDateTime.add(Duration(days: 7 * direction));
          if (_collapseDateTime.month != _dateTime.month) {
            addMonth(_collapseDateTime.month - _dateTime.month);
          }
        },
        pageBuilder: (context, week) => Container(
          child: StreamBuilder<DateTime>(
              stream: _stream,
              builder: (context, snapshot) {
                return GridView.count(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  childAspectRatio: 1.3,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 7,
                  children: List.generate(7, (i) {
                    int day = _collapseDateTime.day + i + week * 7;
                    DateTime dateTime = DateTime(
                        _collapseDateTime.year, _collapseDateTime.month, day);
                    bool notSameMonth = dateTime.month != _dateTime.month;

                    return InkWell(
                      onTap: () {

                        if (notSameMonth) {
                          addMonth(dateTime.month - _dateTime.month);
                        }
                        _collapseDateTime = null;
                        _streamController.sink.add(dateTime);
                        widget.onDateSelected(dateTime);
                      },
                      child: _buildDate(
                        "${dateTime.day}",
                        selected: widget.selected.isNotEmpty &&
                            widget.selected[0]
                                    .difference(dateTime)
                                    .inDays
                                    .abs() <=
                                0,
                        notSameMonth: notSameMonth,
                      ),
                    );
                  }),
                );
              }),
        ),
      ),
    );
  }

  Container _buildDayLayout() {
    _collapseDateTime = null;
    int noOfWeek = ((firstDayOfMonth + daysInMonth) / 7).ceil();
    return Container(
      child: GridView.count(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        childAspectRatio: 1.3,
        children: List.generate(noOfWeek * 7, (i) {
          int day = i - firstDayOfMonth + 1;
          DateTime datetTime = DateTime(_dateTime.year, _dateTime.month, day);
          bool notSameMonth = datetTime.month != _dateTime.month;
          return InkWell(
            onTap: () {
              if (notSameMonth) {
                addMonth(datetTime.month - _dateTime.month);
              }
              _collapseDateTime = null;
              widget.onDateSelected(datetTime);
            },
            child: _buildDate(
              "${datetTime.day}",
              selected: widget.selected.isNotEmpty &&
                  widget.selected[0].millisecondsSinceEpoch ==
                      datetTime.millisecondsSinceEpoch,
              notSameMonth: notSameMonth,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDate(String text,
      {bool selected = false,
      bool notSameMonth = false,
      TextStyle style = const TextStyle()}) {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            notSameMonth ? Colors.black.withOpacity(0.04) : Colors.transparent,
      ),
      child: Container(
        width: 32,
        height: 32,
        child: Text(
          text,
          style: style.copyWith(color: selected ? Colors.white : null),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selected ? theme.accentColor : null, shape: BoxShape.circle),
      ),
    );
  }

  addMonth(int n) {
    setState(() {
      _dateTime = DateTime(_dateTime.year, _dateTime.month + n, _dateTime.day);
    });
  }

  Row _buildMonthControll(String month) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () => addMonth(-1),
          icon: Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            month,
            style: theme.textTheme.headline,
          ),
        ),
        IconButton(
          onPressed: () => addMonth(1),
          icon: Icon(
            Icons.chevron_right,
            size: 32,
          ),
        ),
      ],
    );
  }
}
