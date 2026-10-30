import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/features/settings/application/settings_controller.dart';
import 'package:vnedownloader/main.dart';

void main() {
  testWidgets('VNEDownloader smoke test - verifies header, input, and hero',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const VNEDownloaderApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify app name and header
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('MP4 & MP3 dari YouTube'), findsOneWidget);

    // Verify hero text
    expect(find.text('Simpan video & audio YouTube ke ponsel'), findsOneWidget);

    // Verify input and check button
    expect(find.text('Tautan video'), findsOneWidget);
    expect(find.text('Cek tautan →'), findsOneWidget);
    expect(find.text('Tempel'), findsOneWidget);

    // Verify bottom navigation tabs
    expect(find.text('Unduh'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);

    // Verify FAQ accordion headers
    expect(find.text('Kenapa tautan saya ditolak?'), findsOneWidget);
    expect(find.text('Format apa yang dihasilkan?'), findsOneWidget);
  });
}
