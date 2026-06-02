import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/faq_item.dart';

class FaqFragment extends StatelessWidget {
  const FaqFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildUsageSection(context),
        SizedBox(height: 12),
        buildInstallSection(context),
        SizedBox(height: 12),
        buildConnectivitySection(context),
        //TODO gatewaySection
      ],
    );
  }

  Widget buildUsageSection(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    String title = "Utilisation";
    Map<String, String> questions = {
      t.faqUsageTitle1: t.faqUsageDescription1,
      t.faqUsageTitle2: t.faqUsageDescription2,
      t.faqUsageTitle3: t.faqUsageDescription3,
      t.faqUsageTitle4: t.faqUsageDescription4,
      t.faqUsageTitle5: t.faqUsageDescription5,
      t.faqUsageTitle6: t.faqUsageDescription6,
    };

    List<Widget> questionsViews = [];
    for (var questionEntry in questions.entries) {
      questionsViews.add(
        FaqItem(question: questionEntry.key, answer: questionEntry.value),
      );
      questionsViews.add(SizedBox(height: 5));
    }

    return CustomExpansionTile(title: title, children: questionsViews);
  }

  Widget buildInstallSection(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    String title = "Installation";
    Map<String, String> questions = {
      t.faqInstallationTitle2: t.faqInstallationDescription2,
    };

    List<Widget> questionsViews = [];
    for (var questionEntry in questions.entries) {
      questionsViews.add(
        FaqItem(question: questionEntry.key, answer: questionEntry.value),
      );
      questionsViews.add(SizedBox(height: 5));
    }

    return CustomExpansionTile(title: title, children: questionsViews);
  }

  Widget buildConnectivitySection(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    String title = "Connexion";
    Map<String, String> questions = {
      t.faqConnectivityTitle1: t.faqConnectivityDescription1,
      t.faqConnectivityTitle2: t.faqConnectivityDescription2,
      t.faqConnectivityTitle3: t.faqConnectivityDescription3,
      t.faqConnectivityTitle4: t.faqConnectivityDescription4,
    };

    List<Widget> questionsViews = [];
    for (var questionEntry in questions.entries) {
      questionsViews.add(
        FaqItem(question: questionEntry.key, answer: questionEntry.value),
      );
      questionsViews.add(SizedBox(height: 5));
    }

    return CustomExpansionTile(title: title, children: questionsViews);
  }
}
