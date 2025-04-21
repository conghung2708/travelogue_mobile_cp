// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/model/news_model.dart';

import 'package:travelogue_mobile/representation/event/screens/event_detail.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;
  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          EventDetailScreen.routeName,
          arguments: news,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10)
            .add(EdgeInsets.only(bottom: 15.sp)),
        shadowColor: Colors.grey.withOpacity(0.3),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Container(
            //   width: 140,
            //   height: 140,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(news.image),
            //       fit: BoxFit.cover,
            //     ),
            //     borderRadius: BorderRadius.horizontal(
            //       left: Radius.circular(15.sp),
            //     ),
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(15.sp),
              ),
              child: ImageNetworkCard(
                url: news.imgUrlFirst,
                width: 140,
                height: 140,
              ),
            ),
            SizedBox(width: 10.sp),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 12.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _formatDate(news.createdTime ?? DateTime.now()),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      news.description ?? '',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}
