import 'package:calendar_view/entities/event.dart';
import 'package:calendar_view/views/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCreator extends StatefulWidget {
  EventCreator({this.onEventCreate, this.dateTime, Key key}) : super(key: key);
  final Function onEventCreate;
  final DateTime dateTime;
  @override
  _EventCreatorState createState() => _EventCreatorState();
}

class _EventCreatorState extends State<EventCreator> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildCreateEventForm(context);
  }

  Widget _buildCreateEventForm(context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: theme.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: TextFormField(
              controller: _titleController,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  labelText: "Subject",
                  labelStyle: theme.textTheme.subhead.copyWith(
                    color: Colors.white70,
                  ),
                  border: InputBorder.none),
              style: theme.textTheme.headline.copyWith(color: Colors.white),
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: _buildTextField(
                          label: "On",
                          hintText: "--/--/----",
                          type: TextFieldType.date,
                          controller: _dateController,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildTextField(
                          label: "At",
                          hintText: "--:--",
                          type: TextFieldType.time,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _buildTextField(
                    label: "Note",
                    hintText: "(Optional)",
                    controller: _messageController,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ButtonTheme(
                    minWidth: double.maxFinite,
                    buttonColor: Colors.blueGrey.withOpacity(0.1),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: RaisedButton(
                      elevation: 0,
                      onPressed: createEvent,
                      child: Text(
                        "Create",
                        style: theme.textTheme.subhead
                            .copyWith(color: theme.accentColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String label,
    String hintText,
    TextEditingController controller,
    TextFieldType type = TextFieldType.text,
  }) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: theme.disabledColor),
        ),
        Builder(builder: (_context) {
          return TextFormField(
            controller: controller,
            readOnly: type != TextFieldType.text,
            onTap: type == TextFieldType.text
                ? null
                : () {
                    if (type == TextFieldType.date)
                      showBottomSheet(
                        context: _context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => SafeArea(
                          child: Card(
                            elevation: 16,
                            margin: EdgeInsets.all(0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CalendarView(
                                  monthColor: theme.accentColor,
                                  onDateSelected: (DateTime dateTime) {
                                    controller.text = DateFormat.MMMd()
                                        .addPattern(",")
                                        .add_y()
                                        .format(dateTime);
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    else if (type == TextFieldType.time)
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Card(
                          child: SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[],
                            ),
                          ),
                        ),
                      );
                  },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: theme.disabledColor,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blueGrey.withOpacity(0.3), width: 0.5),
              ),
            ),
          );
        }),
      ],
    );
  }

  createEvent() {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty)
      return;

    widget.onEventCreate(
        Event(title: _titleController.text, message: _messageController.text));

    _titleController.clear();
    _messageController.clear();
  }
}

enum TextFieldType {
  text,
  date,
  time,
}
