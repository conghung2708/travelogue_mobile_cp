import 'package:flutter/material.dart';
import 'package:travelogue_mobile/representation/event/widgets/event_content.dart';
import 'package:travelogue_mobile/representation/widgets/custom_page_appbar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  static const routeName = '/news_screen';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomPageAppBar(
        title: 'Bản Tin Tây Ninh',
      ),
      body: EventContent(showCategory: false),
    );
  }
}
