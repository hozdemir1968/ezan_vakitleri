import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheel_picker/wheel_picker.dart';
import '../components/styles.dart';
import '../controllers/notification_ctrl.dart';
import '../models/notification_m.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationCtrl notificationCtrl = NotificationCtrl();
  final DBService dbService = DBService();
  bool isNotify = false;
  bool isLoading = true;
  Timer? timer;
  List<NotificationM> notificationList = [];

  @override
  void initState() {
    super.initState();
    getNotifications();
    isNotify = true;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getNotifications() async {
    notificationList = await notificationCtrl.loadSettings();
    setState(() {
      isLoading = false;
    });
  }

  saveNotifications() async {
    await notificationCtrl.saveSettings(notificationList);
  }

  deleteNotifications() async {
    await NotificationService.cancelNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bildirim_ayarlari'.tr),
        centerTitle: true,
        elevation: 4,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : hasDataWidget(notificationList),
    );
  }

  Widget hasDataWidget(List<NotificationM> data) {
    Size size = MediaQuery.of(context).size;
    double spaceHeight = size.width / 20;
    List<int> colWidth = [];

    if (size.width > 600) {
      colWidth = [3, 4, 4, 5, 3];
    } else {
      colWidth = [1, 3, 3, 4, 1];
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: spaceHeight),
          Row(
            children: [
              Expanded(flex: colWidth[0], child: Text('')),
              Expanded(
                flex: colWidth[1],
                child: Text("vakit2".tr, style: textStyle18B()),
              ),
              Expanded(
                flex: colWidth[2],
                child: Text("  ${"ac_kapa".tr}", style: textStyle18B()),
              ),
              Expanded(
                flex: colWidth[3],
                child: Text(
                  "sure".tr,
                  textAlign: TextAlign.center,
                  style: textStyle18B(),
                ),
              ),
              Expanded(flex: colWidth[4], child: Text('')),
            ],
          ),
          SizedBox(height: spaceHeight),
          widgetRow(data, 0, colWidth),
          SizedBox(height: spaceHeight),
          widgetRow(data, 1, colWidth),
          SizedBox(height: spaceHeight),
          widgetRow(data, 2, colWidth),
          SizedBox(height: spaceHeight),
          widgetRow(data, 3, colWidth),
          SizedBox(height: spaceHeight),
          widgetRow(data, 4, colWidth),
          SizedBox(height: spaceHeight),
          widgetRow(data, 5, colWidth),
          SizedBox(height: spaceHeight * 2),
          ElevatedButton(
            onPressed: saveNotifications,
            child: Text('kaydet'.tr, style: textStyle16B()),
          ),
          SizedBox(height: spaceHeight),
          ElevatedButton(
            onPressed: () {
              //Navigator.pop(context);
              deleteNotifications();
            },
            child: Text('vazgec'.tr, style: textStyle16()),
          ),
        ],
      ),
    );
  }

  Row widgetRow(List<NotificationM> data, int index, List<int> colWidth) {
    final vakits = [
      'imsak'.tr,
      'gunes'.tr,
      'oglen'.tr,
      'ikindi'.tr,
      'aksam'.tr,
      'yatsi'.tr,
    ];
    const textStyle = TextStyle(fontSize: 28.0, height: 1.1);
    List<int> numbers = List.generate(119, (index) => index - 59);

    return Row(
      children: [
        Expanded(flex: colWidth[0], child: Text('')),
        Expanded(flex: colWidth[1], child: Text(vakits[index], style: textStyle20B())),
        Expanded(
          flex: colWidth[2],
          child: Transform.scale(
            scale: 0.8,
            child: Switch(
              value: data[index].setted!,
              onChanged: (value) {
                setState(() {
                  data[index].setted = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: colWidth[3],
          child: SizedBox(
            height: 40,
            child: WheelPicker(
              itemCount: 118,
              initialIndex: data[index].timeInMinutes!,
              builder:
                  (context, value) =>
                      Text(numbers[value].toString(), style: textStyle22B()),
              selectedIndexColor: Colors.deepOrange,
              looping: false,
              onIndexChanged: (value, interactionType) {
                setState(() {
                  data[index].timeInMinutes = value;
                });
              },
              style: WheelPickerStyle(
                itemExtent: textStyle.fontSize! * textStyle.height!,
                squeeze: 3,
                diameterRatio: 0.8,
                surroundingOpacity: 0.25,
                magnification: 1.2,
              ),
            ),
          ),
        ),
        Expanded(flex: colWidth[4], child: Text('')),
      ],
    );
  }
}

/*
        Expanded(
          flex: colWidth[2],
          child: GestureDetector(
            onTap: () {
              setState(() {
                data[index].setted!
                    ? data[index].setted = false
                    : data[index].setted = true;
              });
            },
            child:
                data[index].setted!
                    ? Icon(Icons.lightbulb_outline)
                    : Icon(Icons.lightbulb),
          ),
        ),


        Expanded(
          flex: colWidth[5],
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 3,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  data[index].timeInMinutes! < 59
                      ? data[index].timeInMinutes = data[index].timeInMinutes! + 1
                      : data[index].timeInMinutes = data[index].timeInMinutes;
                });
              },
              onLongPress: () {
                timer = Timer.periodic(Duration(milliseconds: 75), (timer) {
                  setState(() {
                    data[index].timeInMinutes! < 59
                        ? data[index].timeInMinutes = data[index].timeInMinutes! + 1
                        : data[index].timeInMinutes = data[index].timeInMinutes;
                  });
                });
              },
              onLongPressEnd: (details) => timer?.cancel(),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Text("+", style: textStyle20B()),
              ),
            ),
          ),
        ),
        */
