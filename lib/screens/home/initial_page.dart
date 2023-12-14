import 'package:flutter/material.dart';
import 'package:just_expenses_clone/utils/NotificationApi.dart';
import '../../constants.dart';
import '../analysis/analysis_page.dart';
import '../listing/listing_page.dart';
import '../settings/settings_page.dart';
import 'home_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int pageIndex = 0;

  final pages = [
    HomePage(),
    ListingPage(),
    AnalysisPage(),
    SettingsPage(),
  ];
  @override
  void initState() {
    NotificationApi.init();
    listenNotification();

    var now = DateTime.now();
    NotificationApi.showNotification(
        id: 1,
        title: "Just Expense",
        body: "Don't forget to add your expenses",
        payload: "Initial Notification payload",
        scheduledDate: DateTime(now.year, now.month, now.day, 18, 00));

    super.initState();
  }

  void listenNotification() {
    NotificationApi.onNotification.stream.listen((event) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InitialPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(color: primarySwatch),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? Image.asset("assets/icons/home_dark.png")
                  : Image.asset("assets/icons/home.png")),
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? Image.asset("assets/icons/list_dark.png")
                  : Image.asset("assets/icons/list.png")),
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? Image.asset("assets/icons/analytics.png")
                  : Image.asset("assets/icons/analysis.png")),
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? Image.asset("assets/icons/settings_dark.png")
                  : Image.asset("assets/icons/settings.png"))
        ],
      ),
    );
  }
}
