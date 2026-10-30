import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/download_hero.dart';
import 'widgets/header_bar.dart';
import 'widgets/help_accordion.dart';
import 'widgets/link_input_field.dart';
import 'widgets/recent_downloads_list.dart';

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderBar(),
              SizedBox(height: 6),
              DownloadHero(),
              SizedBox(height: 12),
              LinkInputField(),
              SizedBox(height: 16),
              RecentDownloadsList(),
              SizedBox(height: 12),
              HelpAccordion(),
            ],
          ),
        ),
      ),
    );
  }
}

