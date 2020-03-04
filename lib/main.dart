import 'package:calendar_view/bloc/calendar.dart';
import 'package:calendar_view/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CalendarBloc>(
          create: (_) => CalendarBloc(),
          dispose: (_, CalendarBloc bloc) => bloc.dispose(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // fontFamily: "Yantramanav",
          primarySwatch: Colors.indigo,
          accentColor: Colors.redAccent,
        ),
        darkTheme: ThemeData(
          // fontFamily: "Yantramanav",
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          accentColor: Colors.redAccent,
        ),
        themeMode: ThemeMode.system,
        home: HomePage(title: 'Calendar'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
