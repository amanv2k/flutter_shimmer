import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'placeholders.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shimmer',
      routes: <String, WidgetBuilder>{
        'loading': (_) => const LoadingListPage(),
        'slide': (_) => SlideToUnlockPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingListPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shimmer'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text('Loading List'),
              onTap: () => Navigator.of(context).pushNamed('loading'),
            ),
            ListTile(
              title: const Text('Slide To Unlock'),
              onTap: () => Navigator.of(context).pushNamed('slide'),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingListPage extends StatefulWidget {
  const LoadingListPage({super.key});

  @override
  State<LoadingListPage> createState() => _LoadingListPageState();
}

class _LoadingListPageState extends State<LoadingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              // delay: const Duration(milliseconds: 500),
              period: const Duration(seconds: 1),
              direction: ShimmerDirection.btt,
              enabled: true,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const BannerPlaceholder(),
                    TitlePlaceholder(width: MediaQuery.of(context).size.width),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 4,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              // delay: const Duration(milliseconds: 500),
              period: const Duration(seconds: 1),
              direction: ShimmerDirection.rtl, enabled: true,
              child: const SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: BannerPlaceholder(),
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 4,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              // delay: const Duration(milliseconds: 500),
              period: const Duration(seconds: 1),
              direction: ShimmerDirection.slanted, enabled: true,
              reversed: false,
              child: const BannerPlaceholder(),
            ),
            const Divider(
              color: Colors.black,
              thickness: 4,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              // delay: const Duration(milliseconds: 500),
              period: const Duration(seconds: 1),
              direction: ShimmerDirection.slanted, enabled: true,
              reversed: true,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child:
                    TitlePlaceholder(width: MediaQuery.of(context).size.width),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideToUnlockPage extends StatelessWidget {
  final List<String> days = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  SlideToUnlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime time = DateTime.now();
    final int hour = time.hour;
    final int minute = time.minute;
    final int day = time.weekday;
    final int month = time.month;
    final int dayInMonth = time.day;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide To Unlock'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 48.0,
            right: 0.0,
            left: 0.0,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    '${hour < 10 ? '0$hour' : '$hour'}:${minute < 10 ? '0$minute' : '$minute'}',
                    style: const TextStyle(
                      fontSize: 60.0,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                  ),
                  Text(
                    '${days[day - 1]}, ${months[month - 1]} $dayInMonth',
                    style: const TextStyle(fontSize: 24.0, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 32.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Opacity(
                  opacity: 0.8,
                  child: Shimmer.fromColors(
                    baseColor: Colors.black12,
                    highlightColor: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/chevron_right.png',
                          height: 20.0,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                        ),
                        const Text(
                          'Slide to unlock',
                          style: TextStyle(
                            fontSize: 28.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
