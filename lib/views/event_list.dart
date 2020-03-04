import 'package:calendar_view/entities/event.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  final List<Event> events;

  EventList({this.events, Key key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          color: theme.accentColor,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8)),
              width: 120,
              height: 8,
            ),
          ),
          Expanded(
            child: widget.events?.isEmpty ?? true
                ? Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "No events",
                      style: theme.textTheme.headline
                          .copyWith(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.events?.length ?? 0,
                    itemBuilder: (context, i) {
                      Event event = widget.events[i];
                      return Container(
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                width: 48,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 4,
                                        color: Colors.white38,
                                      ),
                                    ),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 4,
                                        color: Colors.white38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Card(
                                  elevation: 0,
                                  color: Colors.white10,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          event.title,
                                          style: theme.textTheme.subhead
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          event.message,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
