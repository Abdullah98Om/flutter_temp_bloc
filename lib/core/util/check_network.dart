import 'dart:io';

import '../logger/app_logger.dart';

Future<bool> testInternet() async {
  try {
    final List<InternetAddress> result =
        await InternetAddress.lookup('google.com').timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            AppLogger.warning('✗ Internet check timeout');
            return [];
          },
        );
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      AppLogger.info('✓ Internet connection available');
      return true;
    } else {
      AppLogger.warning('✗ Internet connection not available');
      return false;
    }
  } on SocketException catch (e) {
    AppLogger.error('✗ Internet connection error: ', e);

    return false;
  } catch (e) {
    AppLogger.error('✗ Unexpected error in internet check: ', e);

    return false;
  }
}
