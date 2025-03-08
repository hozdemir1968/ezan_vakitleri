import 'package:get/get.dart';
import '../models/praytimes_vm.dart';
import '../models/remaining_time_m.dart';

RemainingTimeM remainingTime(List<PraytimesVM> praytimeVMList) {
  DateTime now = DateTime.now().toLocal();
  RemainingTimeM remainingTimeM = RemainingTimeM(
    vakitIndex: 0,
    nextIndex: 0,
    remainingTime: '...',
  );

  if (praytimeVMList.isNotEmpty) {
    if (now.isBefore(praytimeVMList[0].praytimes![0])) {
      remainingTimeM.vakitIndex = 0;
      remainingTimeM.nextIndex = 5;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[0].praytimes![0], 0);
    } else if (now.isAfter(praytimeVMList[0].praytimes![0]) &&
        now.isBefore(praytimeVMList[0].praytimes![1])) {
      remainingTimeM.vakitIndex = 0;
      remainingTimeM.nextIndex = 1;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[0].praytimes![1], 1);
    } else if (now.isAfter(praytimeVMList[0].praytimes![1]) &&
        now.isBefore(praytimeVMList[0].praytimes![2])) {
      remainingTimeM.vakitIndex = 1;
      remainingTimeM.nextIndex = 2;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[0].praytimes![2], 2);
    } else if (now.isAfter(praytimeVMList[0].praytimes![2]) &&
        now.isBefore(praytimeVMList[0].praytimes![3])) {
      remainingTimeM.vakitIndex = 2;
      remainingTimeM.nextIndex = 3;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[0].praytimes![3], 3);
    } else if (now.isAfter(praytimeVMList[0].praytimes![3]) &&
        now.isBefore(praytimeVMList[0].praytimes![4])) {
      remainingTimeM.vakitIndex = 3;
      remainingTimeM.nextIndex = 4;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[0].praytimes![4], 4);
    } else if (now.isAfter(praytimeVMList[0].praytimes![4]) &&
        now.isBefore(praytimeVMList[0].praytimes![5])) {
      remainingTimeM.vakitIndex = 4;
      remainingTimeM.nextIndex = 5;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[0].praytimes![5], 5);
    } else if (now.isAfter(praytimeVMList[0].praytimes![5]) &&
        now.isBefore(praytimeVMList[1].praytimes![0])) {
      remainingTimeM.vakitIndex = 5;
      remainingTimeM.nextIndex = 0;
      remainingTimeM.remainingTime = kalanSure2(praytimeVMList[1].praytimes![0], 0);
    }
  }
  return remainingTimeM;
}

String kalanSure2(DateTime next, int index) {
  final vakite = [
    'imsaka'.tr,
    'gunesa'.tr,
    'oglena'.tr,
    'ikindia'.tr,
    'aksama'.tr,
    'yatsia'.tr,
  ];
  String kalan = kalanSure(next);
  if (kalan == 'ezan_vakti'.tr) {
    return kalan;
  } else {
    return '${vakite[index]} $kalan .';
  }
}

String kalanSure(DateTime next) {
  DateTime now = DateTime.now().toLocal();
  final difference = next.difference(now);
  if (difference.isNegative) {
    return '';
  } else if (difference.inHours == 0) {
    if (difference.inMinutes == 0) {
      return 'ezan_vakti'.tr;
    } else {
      return '${difference.inMinutes % 60} ${'dakika'.tr}';
    }
  } else if (difference.inMinutes % 60 == 0) {
    return '${difference.inHours} ${'saat'.tr}';
  } else {
    return '${difference.inHours} ${'saat'.tr} ${difference.inMinutes % 60} ${'dakika'.tr}';
  }
}
