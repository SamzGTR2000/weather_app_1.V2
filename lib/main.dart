import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:weather_app_1/screens/daily_screen.dart';
import 'package:weather_app_1/screens/home_screen.dart';
import 'package:weather_app_1/screens/hourly_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: _PageView(),
      title: "Weather",
      debugShowCheckedModeBanner: false,
    );
  }
}

class _PageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('three dots'),
      // ),
      body: PageView(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/thanderstorm/thund.jpeg'),
              fit: BoxFit.cover,
            )), // Set your desired background color
            child: HomeScreen(),
          ),

          // hourly_screen with background color
          Container(
            color: Colors.green, // Set your desired background color
            child: hourly_screen(),
          ),

          // daily_screen with background color
          Container(
            color: Colors.orange, // Set your desired background color
            child: daily_screen(),
          ),
        ],
      ),
    );
  }
}
