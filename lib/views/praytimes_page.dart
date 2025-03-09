import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../components/drawer_menu.dart';
import '../components/styles.dart';
import '../controllers/praytimes_ctrl.dart';
import '../controllers/remaining_time.dart';
import '../models/praytimes_vm.dart';

class PraytimesPage extends StatefulWidget {
  const PraytimesPage({super.key});

  static const routeName = '/praytimespage';

  @override
  State<PraytimesPage> createState() => _PraytimesPageState();
}

class _PraytimesPageState extends State<PraytimesPage> {
  final praytimesCtrl = PraytimesCtrl();
  List<PraytimesVM> praytimesVMList = [];
  final box = GetStorage();
  bool isLoading = true;

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

  Widget hasDataWidget(List<PraytimesVM> praytimes) {
    String lngCode = box.read('lngCode') ?? 'en';
    final vakits = [
      'imsak'.tr,
      'gunes'.tr,
      'oglen'.tr,
      'ikindi'.tr,
      'aksam'.tr,
      'yatsi'.tr,
    ];
    DateTime today = DateTime.now().toLocal();
    today = praytimesCtrl.parseTime("00:00", today.year, today.month, today.day);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(praytimes[0].townName ?? '', style: textStyle20B()),
            background: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('title'.tr, style: textStyle20B())],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(childCount: praytimes.length, (
            context,
            index,
          ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: const Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat.yMMMMEEEEd(
                      lngCode,
                    ).format(praytimes[index].gregorianDate!),
                    style: textStyle20B(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    praytimes[index].hijriDate.toString(),
                    style: textStyle18(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      vakits.map((vakit) => Text(vakit, style: textStyle18())).toList(),
                ),
                today == praytimes[index].gregorianDate!
                    //if today,
                    ? StreamBuilder(
                      stream: Stream.periodic(Duration(seconds: 10)),
                      builder: (context, snapshot) {
                        final remainingtime = remainingTime(praytimes);
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                praytimes[index].praytimes?.length ?? 0,
                                (vakit) {
                                  return Row(
                                    children: [
                                      Text(
                                        DateFormat(
                                          'Hm',
                                        ).format(praytimes[index].praytimes![vakit]),
                                        style:
                                            vakit == remainingtime.vakitIndex
                                                ? textStyle20BT()
                                                : vakit == remainingtime.nextIndex
                                                ? textStyle20BO()
                                                : textStyle18B(),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                remainingtime.remainingTime.toString(),
                                style: textStyle20T(),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                    //if not today
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(praytimes[index].praytimes?.length ?? 0, (
                        vakit,
                      ) {
                        return Text(
                          DateFormat('Hm').format(praytimes[index].praytimes![vakit]),
                          style: textStyle18(),
                        );
                      }),
                    ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
