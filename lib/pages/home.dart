import 'package:calendar_view/entities/event.dart';
import 'package:calendar_view/views/calendar_view.dart';
import 'package:calendar_view/views/event_creator.dart';
import 'package:calendar_view/views/event_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeData get theme => Theme.of(context);
  List<DateTime> _selectedDates = [];

  Map<DateTime, List<Event>> eventMap = {};

  final GlobalKey _calendarKey = GlobalKey();
  double calendarHeight;
  double calendarMinHeight = 160;
  double calendarMaxHeight;

  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    dateTime.subtract(Duration(days: dateTime.weekday));
    _selectedDates.add(DateTime(dateTime.year, dateTime.month, dateTime.day));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      if (calendarMaxHeight == null)
        calendarMaxHeight = _calendarKey.currentContext.size.height;
    });
    super.initState();
  }

  double startY;
  double endY;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        iconTheme: theme.iconTheme.copyWith(color: theme.disabledColor),
        brightness: theme.brightness,
        backgroundColor: theme.canvasColor,
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: calendarHeight,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: CalendarView(
                    key: _calendarKey,
                    collapseView: calendarHeight == calendarMinHeight,
                    selected: _selectedDates,
                    onDateSelected: (datetTime) => setState(() {
                      _selectedDates[0] = datetTime;
                    }),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: EventList(events: eventMap[_selectedDates[0]]),
                  onVerticalDragDown: (DragDownDetails details) {
                    startY = details.localPosition.dy;
                  },
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    endY = details.localPosition.dy;
                    double diff = startY - endY;
                    startY = details.localPosition.dy;

                    double newHeight =
                        (calendarHeight ?? calendarMaxHeight) - diff;

                    

                    if (newHeight >= calendarMinHeight &&
                        newHeight <= calendarMaxHeight)
                      setState(() {
                        calendarHeight = newHeight;
                      });
                  },
                  onVerticalDragEnd: (DragEndDetails details) {
                    double mid = calendarMinHeight +
                        (calendarMaxHeight - calendarMinHeight) / 2;
                    setState(() {
                      calendarHeight =
                          calendarHeight > mid ? null : calendarMinHeight;
                    });
                  },
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => EventCreator(
            onEventCreate: (Event event) {
              setState(() {
                if (!eventMap.containsKey(_selectedDates[0])) {
                  eventMap[_selectedDates[0]] = [];
                }
                eventMap[_selectedDates[0]].add(event);
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: theme.primaryColor,
    );
  }
}