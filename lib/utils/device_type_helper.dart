import 'package:flutter/material.dart';

enum DeviceType {
  phoneSmall,
  phoneMiddle,
  phoneLarge,
  tabletSmall,
  tabletLarge,
  desktopSmall,
  desktopLarge,
}

class DeviceTypeHelper {
  DeviceTypeHelper._();

  /// Most articles suggest to use min width 600.
  /// But in landscape orientation on Android small 7' tablet has min width
  /// around 530 (because of status bar and navigation bar).
  ///
  /// 533 is a size of target device (1280x800, 7 inches)

  static const _kMinWidthForPhoneLargeSmall = 430;
  static const _kMinWidthForTabletsSmall = 533;
  static const _kMinWidthForTabletsLarge = 767;
  static const _kMinWidthForDesktopSmall = 1024;
  static const _kMinWidthForDesktopLarge = 1280;

  static final instance = DeviceTypeHelper._();

  DeviceType _deviceType = DeviceType.phoneLarge;

  DeviceType get deviceType => _deviceType;

  bool get isPhone => _deviceType == DeviceType.phoneLarge;

  bool get isTabletSmall => _deviceType == DeviceType.tabletSmall;

  bool get isTabletLarge => _deviceType == DeviceType.tabletLarge;

  bool get isTablet => isTabletSmall || isTabletLarge;

  bool get isMobile => isPhone || isTablet;

  bool get isDesktopSmall => _deviceType == DeviceType.desktopSmall;

  bool get isDesktopLarge => _deviceType == DeviceType.desktopLarge;

  bool get isDesktop => isDesktopSmall || isDesktopLarge;

  void checkDeviceScreen() {
    final window = WidgetsBinding.instance.window;
    final mediaQueryData = MediaQueryData.fromWindow(window);
    final width = mediaQueryData.size.width;

    _deviceType = DeviceType.phoneSmall;
    if (width < _kMinWidthForPhoneLargeSmall) {
      _deviceType = DeviceType.phoneMiddle;
    } else if (width < _kMinWidthForTabletsSmall) {
      _deviceType = DeviceType.phoneLarge;
    } else if (width < _kMinWidthForTabletsLarge) {
      _deviceType = DeviceType.tabletSmall;
    } else if (width < _kMinWidthForDesktopSmall) {
      _deviceType = DeviceType.tabletLarge;
    } else if (width < _kMinWidthForDesktopLarge) {
      _deviceType = DeviceType.desktopSmall;
    } else {
      _deviceType = DeviceType.desktopLarge;
    }

    print(
      'Smallest width: ${mediaQueryData.size.shortestSide}.\n'
      'Device is ${_deviceType.name}.',
    );
  }
}
