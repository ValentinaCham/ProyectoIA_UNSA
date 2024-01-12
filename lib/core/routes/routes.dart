import 'package:flutter/material.dart';
import 'package:main_app_flutter/pages/home_page.dart';
import 'package:main_app_flutter/pages/home_principal.dart';
import 'package:main_app_flutter/pages/onboarding.dart';
import 'package:main_app_flutter/pages/calendar.dart';

class Routes {
  static const onBoarding = "/";
  static const home = "/home";
  static const todaysTask = "/task/notes";
  static const calendar = "/task/calendar";
}

//Home principal: HomeScreen
//Home camera: HomePage

class RouterGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return MaterialPageRoute(
          builder: ((context) => const OnboardingScreen()),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
      case Routes.todaysTask:
        return MaterialPageRoute(
          builder: ((context) => const HomePage()),
        );
      case Routes.calendar:
        return MaterialPageRoute(
          builder: ((context) => const TodaysTaskScreen()),
        );
      default:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
    }
  }
}
