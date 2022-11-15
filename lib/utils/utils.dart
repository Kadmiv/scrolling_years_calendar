import 'package:scrolling_years_calendar/utils/device_type_helper.dart';

double calculateFontSize(int minSize, int monthsPerRow) {
  final type = DeviceTypeHelper.instance.deviceType;
  return minSize + 4.0 * type.index + 8 / monthsPerRow;
}
