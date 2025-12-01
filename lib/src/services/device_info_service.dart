import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service to collect device and app information
class DeviceInfoService {
  static DeviceInfoService? _instance;
  Map<String, dynamic>? _cachedDeviceInfo;

  DeviceInfoService._();

  static DeviceInfoService get instance {
    _instance ??= DeviceInfoService._();
    return _instance!;
  }

  /// Get device information
  Future<Map<String, dynamic>> getDeviceInfo() async {
    // Return cached info if available
    if (_cachedDeviceInfo != null) {
      return _cachedDeviceInfo!;
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();

      Map<String, dynamic> info = {
        'app_name': packageInfo.appName,
        'app_version': packageInfo.version,
        'app_build': packageInfo.buildNumber,
        'package_name': packageInfo.packageName,
      };

      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        info.addAll({
          'platform': 'web',
          'browser_name': webInfo.browserName.name,
          'user_agent': webInfo.userAgent,
          'vendor': webInfo.vendor,
          'platform_type': webInfo.platform,
        });
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        info.addAll({
          'platform': 'android',
          'os_version': androidInfo.version.release,
          'sdk_int': androidInfo.version.sdkInt,
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'device': androidInfo.device,
          'is_physical_device': androidInfo.isPhysicalDevice,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        info.addAll({
          'platform': 'ios',
          'os_version': iosInfo.systemVersion,
          'model': iosInfo.model,
          'name': iosInfo.name,
          'system_name': iosInfo.systemName,
          'is_physical_device': iosInfo.isPhysicalDevice,
          'identifier': iosInfo.identifierForVendor,
        });
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        info.addAll({
          'platform': 'macos',
          'os_version': macInfo.osRelease,
          'model': macInfo.model,
          'computer_name': macInfo.computerName,
          'host_name': macInfo.hostName,
        });
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        info.addAll({
          'platform': 'windows',
          'os_version': windowsInfo.displayVersion,
          'computer_name': windowsInfo.computerName,
          'number_of_cores': windowsInfo.numberOfCores,
        });
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        info.addAll({
          'platform': 'linux',
          'name': linuxInfo.name,
          'version': linuxInfo.version,
          'id': linuxInfo.id,
          'pretty_name': linuxInfo.prettyName,
        });
      }

      // Cache the info
      _cachedDeviceInfo = info;
      return info;
    } catch (e) {
      // Return minimal info if collection fails
      return {
        'platform': kIsWeb ? 'web' : Platform.operatingSystem,
        'error': 'Failed to collect device info: $e',
      };
    }
  }

  /// Clear cached device info (useful for testing)
  void clearCache() {
    _cachedDeviceInfo = null;
  }
}
