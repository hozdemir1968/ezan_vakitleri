import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../components/drawer_menu.dart';
import '../components/styles.dart';
import '../controllers/praytimes_ctrl.dart';
import '../controllers/remaining_time.dart';
import '../models/praytimes_vm.dart';

class PraytimePage extends StatefulWidget {
  const PraytimePage({super.key});

  static const routeName = '/praytimepage';

  @override
  State<PraytimePage> createState() => _PraytimePageState();
}

class _PraytimePageState extends State<PraytimePage> {
  final praytimesCtrl = PraytimesCtrl();
  List<PraytimesVM> praytimesVMList = [];
  bool isLoading = true;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    praytimesVMList = await praytimesCtrl.getPraytimesVMList();
    setState(() {
      praytimesVMList[0].townId!.isNegative ? isLoading = true : isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading ? Text('Ezan Vakitleri') : Text(praytimesVMList[0].townName!),
        centerTitle: true,
        elevation: 4,
      ),
      drawer: DrawerMenu(),
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : hasDataWidget(praytimesVMList),
      ),
    );
  }

  Widget hasDataWidget(List<PraytimesVM> praytimeVMList) {
    Size size = MediaQuery.of(context).size;
    double spaceHeight = size.width / 25;
    double rowHeight = size.width / 12;
    List<double> colWidth = [];
    if (size.width > 600) {
      colWidth = [
        size.width * 0.10,
        size.width * 0.24,
        size.width * 0.24,
        size.width * 0.28,
        size.width * 0.10,
      ];
    } else {
      colWidth = [
        size.width * 0.01,
        size.width * 0.22,
        size.width * 0.22,
        size.width * 0.48,
        size.width * 0.01,
      ];
    }
    String lngCode = box.read('lngCode') ?? 'en';
    final vakits = [
      'imsakk'.tr,
      'gunesk'.tr,
      'oglenk'.tr,
      'ikindik'.tr,
      'aksamk'.tr,
      'yatsik'.tr,
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: spaceHeight * 0.5),
          Text(
            DateFormat.yMMMMEEEEd(lngCode).format(praytimeVMList[0].gregorianDate!),
            style: textStyle20B(),
          ),
          Text(praytimeVMList[0].hijriDate.toString(), style: textStyle18()),
          SizedBox(height: spaceHeight),
          Row(
            children: [
              SizedBox(height: rowHeight, width: colWidth[0], child: Text('')),
              SizedBox(
                height: rowHeight,
                width: colWidth[1],
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text('vakit'.tr, style: textStyle18B()),
                ),
              ),
              SizedBox(
                height: rowHeight,
                width: colWidth[2],
                child: Text('vakti'.tr, style: textStyle18B()),
              ),
              SizedBox(
                height: rowHeight,
                width: colWidth[3],
                child: Text('kalan'.tr, style: textStyle18B()),
              ),
              SizedBox(height: rowHeight, width: colWidth[4], child: Text('')),
            ],
          ),
          ...List.generate(vakits.length, (index) {
            return Row(
              children: [
                SizedBox(height: rowHeight, width: colWidth[0], child: Text('')),
                SizedBox(
                  height: rowHeight,
                  width: colWidth[1],
                  child: Text('  ${vakits[index]}', style: textStyle18B()),
                ),
                SizedBox(
                  height: rowHeight,
                  width: colWidth[2],
                  child: Text(
                    DateFormat('Hm').format(praytimeVMList[0].praytimes![index]),
                    style: textStyle18B(),
                  ),
                ),
                StreamBuilder(
                  stream: Stream.periodic(Duration(seconds: 10)),
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: rowHeight,
                      width: colWidth[3],
                      child: Text(
                        kalanSure(praytimeVMList[0].praytimes![index]),
                        style: textStyle18(),
                      ),
                    );
                  },
                ),
                SizedBox(height: rowHeight, width: colWidth[4], child: Text('')),
              ],
            );
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Image.asset('assets/images/divider2.png', width: Get.size.width * 0.5),
          ),
          // daily
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Bir Ayet:', style: textStyle18B())],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ', style: textStyle26B()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              praytimeVMList[0].dailyVM!.verse.toString(),
              style: textStyle18(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(praytimeVMList[0].dailyVM!.verseSource.toString())],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Bir Hadis:', style: textStyle18B())],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              praytimeVMList[0].dailyVM!.hadith.toString(),
              style: textStyle18(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(praytimeVMList[0].dailyVM!.hadithSource.toString())],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Bir Dua:', style: textStyle18B())],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                praytimeVMList[0].dailyVM!.pray.toString(),
                style: textStyle18(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [Text(praytimeVMList[0].dailyVM!.praySource.toString())],
            ),
          ),
          SizedBox(height: spaceHeight),
        ],
      ),
    );
  }
}
