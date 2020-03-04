import 'dart:async';

import 'package:calendar_view/bloc/calendar.dart';
import 'package:calendar_view/entities/event.dart';
import 'package:calendar_view/views/calendar_view_basic.dart';
import 'package:calendar_view/views/calendar_view_collapse.dart';
import 'package:calendar_view/views/calendar_view_date.dart';
import 'package:calendar_view/views/calendar_view_month_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:infinite_view_pager/infinite_view_pager.dart';
import 'package:provider/provider.dart';

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
  List<String> dateLabels;

  CalendarBloc get bloc {
    return Provider.of<CalendarBloc>(context, listen: false);
  }

  int get daysInMonth {
    DateTime _dateTime = bloc.monthDateTime;
    return DateTime(_dateTime.year, _dateTime.month + 1, 1)
        .subtract(Duration(days: 1))
        .day;
  }

  int get firstDayOfMonth {
    DateTime _dateTime = bloc.monthDateTime;
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<DateTime>(
          stream: bloc.monthStream,
          builder: (context, snapshot) {
            DateTime dateTime = snapshot.data ?? DateTime.now();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildMonthControll(dateTime),
                SizedBox(
                  height: 8,
                ),
                _buildDayHeader(),
                widget.collapseView
                    ? CalanderViewCollapse(
                        events: widget.events,
                        onDateSelected: widget.onDateSelected,
                        selected: widget.selected,
                      )
                    : CalanderViewBasic(
                        events: widget.events,
                        onDateSelected: widget.onDateSelected,
                        selected: widget.selected,
                      ),
                SizedBox(height: 12)
              ],
            );
          }),
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
          return CalendarViewDate(dateLabels[i],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ));
        }),
      ),
    );
  }

  Row _buildMonthControll(DateTime monthDateTime) {
    String month = DateFormat("MMMM yyyy").format(monthDateTime);

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
          child: InkWell(
            onTap: showMonthPicker,
            child: Container(
              child: Text(
                month,
                style: theme.textTheme.headline,
              ),
            ),
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

  void showMonthPicker() {
    showDialog(context: context, builder: (_) => CalendarViewMonthPicker());
  }

  void addMonth(int n) {
    DateTime _dateTime = bloc.monthDateTime;
    updateDate(DateTime(_dateTime.year, _dateTime.month + n, _dateTime.day));
  }

  void addYear(int n) {
    DateTime _dateTime = bloc.monthDateTime;

    updateDate(DateTime(_dateTime.year + n, _dateTime.month, _dateTime.day));
  }

  void updateDate(DateTime dateTime) {
    bloc.updateMonth(dateTime);
  }
}
