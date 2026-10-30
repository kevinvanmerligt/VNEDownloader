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
    final primaryColor = Theme.of(context).colorScheme.primary;
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
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Input field container matching the photo
          TextField(
            controller: _urlController,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppConstants.textLight : AppConstants.textDark,
            ),
            onSubmitted: (_) => _handleCheckLink(),
            onChanged: (_) {
              if (downloadState.errorMessage != null) {
                ref.read(downloadControllerProvider.notifier).clearError();
              }
            },
            decoration: InputDecoration(
              hintText: strings.linkFieldPlaceholder,
              hintStyle: TextStyle(
                color: isDark ? AppConstants.textLightMuted : AppConstants.textMuted,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.link_rounded,
                color: isDark ? AppConstants.textLightMuted : const Color(0xFF6B7280),
                size: 20,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: InkWell(
                  onTap: _handlePaste,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF222222) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.content_paste_rounded,
                          size: 14,
                          color: isDark ? AppConstants.textLight : const Color(0xFF4B5563),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          strings.pasteButton,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppConstants.textLight : const Color(0xFF374151),
                          ),
                        ),
                      ],
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
                color: isDark ? AppConstants.darkStatusFailedLight : AppConstants.statusFailedLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (isDark ? AppConstants.darkStatusFailed : AppConstants.statusFailed)
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: isDark ? AppConstants.darkStatusFailed : AppConstants.statusFailed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      downloadState.errorMessage!,
                      style: TextStyle(
                        color: isDark ? AppConstants.darkStatusFailed : const Color(0xFF991B1B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Main Action Button "Cek tautan →" matching the photo
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: downloadState.isChecking ? null : _handleCheckLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: downloadState.isChecking
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
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
                            fontSize: 15.5,
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
