import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vnedownloader/app/l10n/app_localizations.dart';
import 'package:vnedownloader/core/constants/app_constants.dart';
import 'package:vnedownloader/features/download/application/download_controller.dart';
import 'quality_bottom_sheet.dart';

class LinkInputField extends ConsumerStatefulWidget {
  const LinkInputField({super.key});

  @override
  ConsumerState<LinkInputField> createState() => _LinkInputFieldState();
}

class _LinkInputFieldState extends ConsumerState<LinkInputField> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _handlePaste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null && mounted) {
      _urlController.text = clipboardData!.text!.trim();
      ref.read(downloadControllerProvider.notifier).clearError();
    }
  }

  Future<void> _handleCheckLink() async {
    FocusScope.of(context).unfocus();
    final url = _urlController.text.trim();
    final videoInfo =
        await ref.read(downloadControllerProvider.notifier).checkUrl(url);

    if (videoInfo != null && mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => QualityBottomSheet(videoInfo: videoInfo),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final downloadState = ref.watch(downloadControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label "Tautan video"
          Text(
            strings.linkFieldLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Input field container
          TextField(
            controller: _urlController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleCheckLink(),
            onChanged: (_) {
              if (downloadState.errorMessage != null) {
                ref.read(downloadControllerProvider.notifier).clearError();
              }
            },
            decoration: InputDecoration(
              hintText: strings.linkFieldPlaceholder,
              prefixIcon: const Icon(
                Icons.link_rounded,
                color: AppConstants.primaryColor,
                size: 22,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: TextButton.icon(
                  onPressed: _handlePaste,
                  icon: const Icon(Icons.content_paste_rounded, size: 16),
                  label: Text(strings.pasteButton),
                  style: TextButton.styleFrom(
                    foregroundColor: AppConstants.primaryColor,
                    visualDensity: VisualDensity.compact,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Inline Error Message if invalid
          if (downloadState.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.statusFailedLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstants.statusFailed.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppConstants.statusFailed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      downloadState.errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFF991B1B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Main Action Button "Cek tautan →"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: downloadState.isChecking ? null : _handleCheckLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                disabledBackgroundColor: AppConstants.primaryColor.withOpacity(0.6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: downloadState.isChecking
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          strings.checkingLink,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          strings.checkLinkButton,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
