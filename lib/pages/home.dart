import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThemeData get theme => Theme.of(context);
  DateTime _dateTime = DateTime.now();
  List<DateTime> _selectedDates = [];
  List<String> dateLabels;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  Map<DateTime, List<Event>> eventMap = {};
  addMonth(int n) {
    setState(() {
      _dateTime = DateTime(_dateTime.year, _dateTime.month + n, _dateTime.day);
    });
  }

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
    dateTime.subtract(Duration(days: dateTime.weekday));
    DateFormat dateFormat = DateFormat.E();
    _selectedDates
        .add(DateTime(_dateTime.year, _dateTime.month, _dateTime.day));
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
  Widget build(BuildContext context) {
    String month = DateFormat("MMMM yyyy").format(_dateTime);

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
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildMonthControll(month),
              SizedBox(
                height: 32,
              ),
              _buildDayHeader(),
              _buildDayLayout(),
              Divider(height: 1,color: theme.disabledColor,),
              Expanded(
                child: _buildEvents(),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildEvents() {
    List<Event> events = eventMap[_selectedDates[0]];
    return ListView.builder(
      shrinkWrap: true,
      itemCount: events?.length ?? 0,
      itemBuilder: (context, i) {
        Event event = events[i];
        return Container(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.title,
                    style: theme.textTheme.subhead
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(event.message),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: _buildCreateEventForm,
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget _buildCreateEventForm(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Add Event",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(hintText: "Message"),
                ),
                SizedBox(
                  height: 24,
                ),
                ButtonTheme(
                  minWidth: double.maxFinite,
                  child: RaisedButton(
                    onPressed: createEvent,
                    child: Text(
                      "Create",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  createEvent() {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty)
      return;

    setState(() {
      if (!eventMap.containsKey(_selectedDates[0])) {
        eventMap[_selectedDates[0]] = [];
      }
      eventMap[_selectedDates[0]].add(
        Event(title: _titleController.text, message: _messageController.text),
      );

      _titleController.clear();
      _messageController.clear();
    });
    Navigator.of(context).pop();
  }

  Container _buildDayHeader() {
    return Container(
      child: GridView.count(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 7,
        children: List.generate(7, (i) {
          return _buildDate(dateLabels[i]);
        }),
      ),
    );
  }

  Container _buildDayLayout() {
    return Container(
      child: GridView.count(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        children: List.generate(firstDayOfMonth + daysInMonth, (i) {
          int day = i - firstDayOfMonth + 1;
          DateTime datetTime = DateTime(_dateTime.year, _dateTime.month, day);
          return day > 0
              ? InkWell(
                  onTap: () => setState(() {
                    _selectedDates[0] = datetTime;
                  }),
                  child: _buildDate("$day",
                      selected: _selectedDates[0].millisecondsSinceEpoch ==
                          datetTime.millisecondsSinceEpoch),
                )
              : Container();
        }),
      ),
    );
  }

  Widget _buildDate(String text, {bool selected = false}) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 32,
        height: 32,
        child: Text(
          text,
          style: TextStyle(color: selected ? Colors.white : null),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selected ? theme.accentColor : null, shape: BoxShape.circle),
      ),
    );
  }

  Row _buildMonthControll(String month) {
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

class Event {
  String title;
  String message;

  Event({this.title, this.message});
}
