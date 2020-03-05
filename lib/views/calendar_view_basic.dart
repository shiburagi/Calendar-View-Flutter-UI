import 'package:calendar_view/bloc/calendar.dart';
import 'package:calendar_view/entities/event.dart';
import 'package:calendar_view/views/calendar_view_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalanderViewBasic extends StatefulWidget {
  final List<Event> events;
  final List<DateTime> selected;
  final Function onDateSelected;

  CalanderViewBasic(
      {this.events, this.onDateSelected, this.selected = const [], Key key})
      : super(key: key);

  @override
  _CalanderViewBasicState createState() => _CalanderViewBasicState();
}

class _CalanderViewBasicState extends State<CalanderViewBasic> {
  CalendarBloc bloc;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    bloc.collapseDateTime = null;

    return StreamBuilder<DateTime>(
        stream: bloc.monthStream,
        builder: (context, snapshot) {
          return _buildDayLayout(snapshot.data ?? bloc.monthDateTime);
        });
  }

  Widget _buildDayLayout(DateTime month) {
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
          DateTime datetTime = DateTime(month.year, month.month, day);
          bool notSameMonth = datetTime.month != month.month;
          return InkWell(
            onTap: () {
              if (notSameMonth) {
                addMonth(datetTime.month - month.month);
              }
              bloc.collapseDateTime = null;
              widget.onDateSelected(datetTime);
            },
            child: CalendarViewDate(
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

  void addMonth(int n) {
    DateTime _dateTime = bloc.monthDateTime;
    updateDate(DateTime(_dateTime.year, _dateTime.month + n, _dateTime.day));
  }

  void updateDate(DateTime dateTime) {
    bloc.updateMonth(dateTime);
  }
}
