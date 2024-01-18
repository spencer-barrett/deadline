import 'package:deadline/auth.dart';
import 'package:deadline/deadline_logic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<List> allDeadlines = Deadline().getDeadlines();
  int extraindex = 0;
  int firstIndex = 0;
  void initState() {
    super.initState();
    _getPoints();
  }

  final User? user = Auth().currentUser;
  final _titleKey = GlobalKey<FormState>();
  final _dateKey = GlobalKey<FormState>();
  final _descKey = GlobalKey<FormState>();
  String? errorMessage = '';
  final Future<List> deadlineList = Deadline().getRecentDeadline();
  final db = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  Future<void> completeDeadline(
    String id,
  ) async {
    await Deadline().deleteDeadline(id: id);
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<List> doNothing() async {
    Future<List> d = Deadline().getRecentDeadline();
    List dd = await d;
    return dd;
  }

  Future<void> _getPoints() async {
    QuerySnapshot qs = await db.collection('users').get();
    final allData = qs.docs.map((doc) => doc.data()).toList();

    print(user?.email);
  }

  Widget _homeWidget() {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Color.fromARGB(255, 238, 238, 238),
              Color.fromARGB(255, 213, 213, 213),
              Color.fromARGB(255, 169, 169, 169),
              Color.fromARGB(255, 136, 136, 136),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 70),
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
              padding: EdgeInsets.all(10),
              child: Card(
                child: Center(
                  child: Text('Points: 12'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 120),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300,
                  child: Card(
                    color: Colors.greenAccent,
                    child: Center(
                      child: Card(
                        color: Color.fromARGB(255, 246, 246, 246),
                        margin: const EdgeInsets.all(20),
                        child: Container(
                          alignment: Alignment.center,
                          child: FutureBuilder(
                              future: Deadline().getRecentDeadline(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Card(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: SizedBox(
                                                height: 50,
                                                child: Center(
                                                  child: Text('Deadline'),
                                                ))),
                                        Card(
                                            margin: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 20),
                                            child: Center(
                                              child: Column(children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(snapshot.data!
                                                        .elementAt(3)
                                                        .toString())),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(snapshot.data!
                                                        .elementAt(2)
                                                        .toString())),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(snapshot.data!
                                                        .elementAt(0)
                                                        .toString())),
                                              ]),
                                            ))
                                      ]);
                                } else if (snapshot.hasError) {
                                  return const Text('no data');
                                }
                                return const CircularProgressIndicator();
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ))),
                onPressed: () async {
                  await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: _newDeadlineWidget(),
                          ));
                },
                // child: const Text('Create new Deadline'),
                child: const Text('Create new Deadline'),
              ),
            ),
          ],
        ));
  }

  Widget _form(
    String label,
    Key fk,
    TextEditingController controller,
    bool pass,
  ) {
    final ThemeData theme = Theme.of(context);

    return Form(
        key: fk,
        child: TextFormField(
          obscureText: pass,
          controller: controller,
          decoration: InputDecoration(
              labelText: label, labelStyle: theme.textTheme.bodySmall),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter something';
            }
            return null;
          },
        ));
  }

  Future<void> submitDeadline() async {
    try {
      await Deadline().createDeadline(
          title: _titleController.text,
          dueDate: _dateController.text,
          description: _descController.text);
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = e.message;
        print(errorMessage);
      });
    }
  }

  Widget _newDeadlineWidget() {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'New Deadline',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Card(
          color: Colors.greenAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(15),
                child: _form('Title:', _titleKey, _titleController, false),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: _form('Due Date:', _dateKey, _dateController, false),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: _form('Description:', _descKey, _descController, false),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      minimumSize:
                          MaterialStateProperty.all(const Size(120, 40)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      )),
                  onPressed: () {
                    submitDeadline();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'submit',
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(120, 40)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ))),
                onPressed: () => Navigator.pop(context),
                child: const Text('back'))),
      ],
    );
  }

  Widget _deadlinesWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 600,
              child: Card(
                color: Color(0xff15d281),
                child: Center(
                  child: Card(
                    color: const Color.fromARGB(255, 7, 231, 193),
                    margin: const EdgeInsets.all(20),
                    child: Container(
                      alignment: Alignment.center,
                      child: Card(
                          child: FutureBuilder(
                              future: Deadline().getDeadlines(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // int track1 = 0;
                                        // int track2 = 0;
                                        // if (index == 1) {}
                                        // if (index == 2) {}
                                        return Card(
                                            child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: CustomScrollView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    slivers: <Widget>[
                                                      SliverPadding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        sliver: SliverList(
                                                            delegate:
                                                                SliverChildListDelegate(<Widget>[
                                                          Center(
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1),
                                                                  child: Text(
                                                                      '${snapshot.data?.elementAt(index).elementAt(0)}'))),
                                                          Center(
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1),
                                                                  child: Text(
                                                                      '${snapshot.data?.elementAt(index).elementAt(1)}'))),
                                                          Center(
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1),
                                                                  child: Text(
                                                                      '${snapshot.data?.elementAt(index).elementAt(2)}'))),
                                                          Center(
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1),
                                                                  child: Text(
                                                                      '${snapshot.data?.elementAt(index).elementAt(3)}'))),
                                                          const Center(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1),
                                                            child: ElevatedButton(
                                                                onPressed: null,
                                                                child: const Text(
                                                                    'Complete')),
                                                          ))
                                                        ])),
                                                      )
                                                    ])));
                                      });
                                  //
                                } else if (snapshot.hasError) {
                                  return const Text('no data');
                                }
                                return const CircularProgressIndicator();
                              })),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _storeWidget() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Leader: ${user?.email}       points: 12'),
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
    return Scaffold(
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
            selectedIcon: Icon(Icons.view_timeline),
            icon: Icon(Icons.view_timeline_outlined),
            label: 'Deadlines',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.leaderboard),
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Leaderboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        _homeWidget(),
        _deadlinesWidget(),
        _storeWidget(),
        _settingsWidget()
      ][currentPageIndex],
    );
  }
}
