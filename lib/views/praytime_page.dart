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
      appBar: AppBar(title: Text('title'.tr), centerTitle: true, elevation: 4),
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
    String lngCode = box.read('lngCode');
    final vakits = [
      'imsakk'.tr,
      'gunesk'.tr,
      'oglenk'.tr,
      'ikindik'.tr,
      'aksamk'.tr,
      'yatsik'.tr,
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMMMMEEEEd(lngCode).format(praytimeVMList[0].gregorianDate!),
                style: textStyle20B(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(praytimeVMList[0].hijriDate.toString(), style: textStyle18()),
            ),
            SizedBox(height: 30),
            Table(
              columnWidths: {
                0: FractionColumnWidth(0.25),
                1: FractionColumnWidth(0.30),
                2: FractionColumnWidth(0.45),
              },
              children: [
                TableRow(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        'vakit'.tr,
                        textAlign: TextAlign.left,
                        style: textStyle18B(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        'vakti'.tr,
                        textAlign: TextAlign.center,
                        style: textStyle18B(),
                      ),
                    ),
                    SizedBox(height: 30, child: Text('kalan'.tr, style: textStyle18B())),
                  ],
                ),
                ...List.generate(vakits.length, (index) {
                  return TableRow(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Text('  ${vakits[index]}', style: textStyle18B()),
                      ),
                      SizedBox(
                        height: 30,
                        child: Text(
                          DateFormat('Hm').format(praytimeVMList[0].praytimes![index]),
                          textAlign: TextAlign.center,
                          style: textStyle18B(),
                        ),
                      ),
                      StreamBuilder(
                        stream: Stream.periodic(Duration(seconds: 10)),
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 30,
                            child: Text(
                              kalanSure(praytimeVMList[0].praytimes![index]),
                              style: textStyle18(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Image.asset(
                'assets/images/divider2.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bir Ayet:', style: textStyle18B()),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ',
                      style: textStyle26B(),
                    ),
                  ),
                ),
                Text(praytimeVMList[0].dailyVM!.verse.toString(), style: textStyle18()),
                Text(praytimeVMList[0].dailyVM!.verseSource.toString()),
                SizedBox(height: 15),
                Text('Bir Hadis:', textAlign: TextAlign.right, style: textStyle18B()),
                SizedBox(height: 10),
                Text(praytimeVMList[0].dailyVM!.hadith.toString(), style: textStyle18()),
                Text(praytimeVMList[0].dailyVM!.hadithSource.toString()),
                SizedBox(height: 15),
                Text('Bir Dua:', textAlign: TextAlign.right, style: textStyle18B()),
                SizedBox(height: 10),
                Text(praytimeVMList[0].dailyVM!.pray.toString(), style: textStyle18()),
                Text(praytimeVMList[0].dailyVM!.praySource.toString()),
                SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
