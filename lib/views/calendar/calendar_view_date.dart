import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalendarViewDate extends StatefulWidget {
  CalendarViewDate(this.text,
      {this.selected = false,
      this.notSameMonth = false,
      this.style = const TextStyle(),
      Key key})
      : super(key: key);
  final String text;
  final bool selected;
  final bool notSameMonth;
  final TextStyle style;

  @override
  _CalendarViewDateState createState() => _CalendarViewDateState();
}

class _CalendarViewDateState extends State<CalendarViewDate> {
  @override
  Widget build(BuildContext context) {
    return _buildDate();
  }

  Widget _buildDate() {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.notSameMonth
            ? Colors.black.withOpacity(0.06)
            : Colors.transparent,
      ),
      child: Container(
        width: 32,
        height: 32,
        child: Text(
          widget.text,
          style: widget.style
              .copyWith(color: widget.selected ? Colors.white : null),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: widget.selected ? theme.accentColor : null,
            shape: BoxShape.circle),
      ),
    );
  }
}
