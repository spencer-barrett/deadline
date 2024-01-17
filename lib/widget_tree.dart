import 'package:deadline/auth.dart';
import 'package:deadline/home_page.dart';
import 'package:deadline/welcome_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Is Loading..."));
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          print('Snapshot => $snapshot');
          return HomePage();
        } else {
          print('Not Logged In!!!');
          return WelcomePage();
        }
      },
    );
  }
}
