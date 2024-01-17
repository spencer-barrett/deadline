import 'package:deadline/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _homeWidget() {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 70, bottom: 70),
          child: Container(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              'images/Logo.svg',
              semanticsLabel: 'Logo',
              height: 50,
              width: 200,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 300,
              child: Card(
                color: const Color(0xff15d281),
                child: Center(
                  child: Text(
                    'Home',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ),
        ),
        Card(
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Card(
                  color: const Color.fromARGB(255, 255, 147, 7),
                  child: Center(
                    child: Text(
                      'Test',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )),
            ))
      ],
    );
  }

  Widget _storeWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsWidget() {
    return Container(
        color: const Color.fromARGB(255, 228, 228, 228),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Colors.greenAccent,
                child: Container(
                  alignment: Alignment.center,
                  // height: 600,
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          height: 50,
                          width: 100,
                          child: Card(
                            color: Color(0xffF069AB),
                            child: Center(child: Text('Settings')),
                          ),
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9.0))),
                              height: 50,
                              // color: Colors.amber[600],
                              child: const Center(child: Text('Entry A')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9.0))),
                              height: 50,
                              child: const Center(child: Text('Entry B')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9.0))),
                              height: 50,
                              child: const Center(child: Text('Entry C')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Colors.lightGreenAccent,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Center(
                    // padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStateProperty.all(const Size(120, 40)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ))),
                      onPressed: signOut,
                      child: const Text('Sign Out'),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      //   backgroundColor: Colors.transparent,
      // ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color(0xff15d281),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.store),
            icon: Icon(Icons.store_outlined),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        _homeWidget(),
        _storeWidget(),
        _settingsWidget()
      ][currentPageIndex],
    );
  }
}
