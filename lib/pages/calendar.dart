import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:main_app_flutter/core/res/color.dart';
import 'package:main_app_flutter/models/task.dart';
import 'package:main_app_flutter/widgets/circle_gradient_icon.dart';
import 'package:main_app_flutter/widgets/task.dart';
import 'package:main_app_flutter/core/res/app.dart';
import 'dart:convert';

class TodaysTaskScreen extends StatefulWidget {
  const TodaysTaskScreen({Key? key}) : super(key: key);

  @override
  State<TodaysTaskScreen> createState() => _TodaysTaskScreenState();
}

class _TodaysTaskScreenState extends State<TodaysTaskScreen> {
  List _taskList = [];
  final todaysDate = DateTime.now();
  late int _dateIndex;
  final double _width = 70;
  final double _margin = 15;
  final _scrollController = ScrollController();
  late int days;

  Future<void> loadData() async {
    final String response = await rootBundle.loadString(AppConstants.calendar);
    final data = await json.decode(response);
    setState(() {
      _taskList = data;
    });
  }

  List<TaskModel> getTasks(List data) {
    List<TaskModel> taskList = [];

    data.forEach((value) {
      taskList.add(TaskModel(
        from: DateTime(
          value['from'][0],
          value['from'][1],
          value['from'][2],
          value['from'][3],
          value['from'][4],
        ),
        to: DateTime(
          value['to'][0],
          value['to'][1],
          value['to'][2],
          value['to'][3],
          value['to'][4],
        ),
        taskName: value['taskName'],
      ));
    });

    return taskList;
  }

  void getDates() {
    final date = DateTime(todaysDate.year, todaysDate.month);
    days = DateTimeRange(
      start: date,
      end: DateTime(todaysDate.year, todaysDate.month + 1),
    ).duration.inDays;
    _dateIndex = todaysDate.day;
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _scroll();
      },
    );
    setState(() {});
  }

  void _scroll() {
    _scrollController.animateTo(
      (days * _dateIndex.toDouble()) +
          (_dateIndex.toDouble() * _width) -
          (_dateIndex * _margin),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeIn,
    );
  }

  @override
  void initState() {
    getDates();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas del Día"),
      ),
      body: _buildBody(context),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildDateHeader(context),
          const SizedBox(
            height: 20,
          ),
          _buildDateDays(),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: getTasks(_taskList)
                .map(
                  (e) => TaskWidget(
                    taskModel: e,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Row _buildDateHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat("MMMM, dd").format(todaysDate),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "10 Task Today",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CircleGradientIcon(
            onTap: () {},
            icon: Icons.calendar_month,
            color: Colors.purple,
            iconSize: 24,
            size: 50,
          ),
        ),
      ],
    );
  }

  SizedBox _buildDateDays() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final monthDate =
              DateTime(todaysDate.year, todaysDate.month, index + 1);
          return InkWell(
            onTap: () {
              _dateIndex = index;
              _scroll();
            },
            child: Container(
              width: _width,
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: _margin,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: todaysDate.day == (index + 1)
                    ? AppColors.getLinearGradient(Colors.orange)
                    : null,
                borderRadius: BorderRadius.circular(65),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0.2,
                    //   offset: const Offset(2, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${index + 1}",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: todaysDate.day == (index + 1)
                            ? Colors.white
                            : null),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('EEE').format(monthDate),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: todaysDate.day == (index + 1)
                              ? Colors.white
                              : null,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
