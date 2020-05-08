import 'package:calendar_view/entities/event.dart';
import 'package:calendar_view/pages/calendar.dart';
import 'package:calendar_view/views/event_creator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController appBarAnimationController;

  PersistentBottomSheetController _bottomSheetController;

  ThemeData get theme => Theme.of(context);
  List<DateTime> _selectedDates = [];
  Map<DateTime, List<Event>> eventMap = {};

  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    dateTime.subtract(Duration(days: dateTime.weekday));
    _selectedDates.add(DateTime(dateTime.year, dateTime.month, dateTime.day));

    super.initState();

    appBarAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

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
      body: CalendarPage(
        events: eventMap,
        selectedDates: _selectedDates,
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    bool isShowBottomSheet = _bottomSheetController != null;
    return Builder(builder: (_context) {
      return FloatingActionButton(
        onPressed: () {
          if (isShowBottomSheet) {
            _bottomSheetController.close();
          } else
            setState(() {
              _bottomSheetController = showBottomSheet(
                context: _context,
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
              _bottomSheetController.closed.then((_) {
                setState(() {
                  _bottomSheetController = null;
                });
              });
            });
        },
        child: Icon(
          isShowBottomSheet ? Icons.clear : Icons.add,
          color: isShowBottomSheet ? theme.errorColor : null,
        ),
        backgroundColor:
            isShowBottomSheet ? theme.canvasColor : theme.primaryColor,
      );
    });
  }
}
