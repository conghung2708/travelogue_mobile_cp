// // news_section_highlighted.dart
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:travelogue_mobile/model/news_model.dart';
// import 'package:travelogue_mobile/representation/news/widgets/spotlight_news.dart';
// import 'package:travelogue_mobile/representation/news/widgets/highlight_stack.dart';
// import 'package:travelogue_mobile/representation/experience/widgets/experience_new_card.dart';
// import 'package:travelogue_mobile/representation/experience/screens/experience_detail_screen.dart';

// class NewsSectionHighlighted extends StatelessWidget {
//   final List<NewsModel> allNews;
//   final bool listShowsAll; // true = list dưới hiển thị tất cả; false = bỏ các bài highlighted khỏi list
//   const NewsSectionHighlighted({
//     super.key,
//     required this.allNews,
//     this.listShowsAll = true,
//   });

//   void _openDetail(BuildContext context, NewsModel n) {
//     Navigator.pushNamed(context, ExperienceDetailScreen.routeName, arguments: n);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final highlighted = allNews.where((e) => e.isHighlighted == true).toList();
//     final firstSpotlight = highlighted.isNotEmpty ? highlighted.first : null;

//     final listItems = listShowsAll
//         ? allNews
//         : allNews.where((e) => e.isHighlighted != true).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [R
//         if (firstSpotlight != null) ...[
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             child: SpotlightNews(
//               news: firstSpotlight,
//               onTap: () => _openDetail(context, firstSpotlight),
//             ),
//           ),
//           SizedBox(height: 1.6.h),
//         ],
//         if (highlighted.length > 1) ...[
//           HighlightStack(highlighted: highlighted.skip(1).toList()),
//           SizedBox(height: 1.6.h),
//         ],
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 4.w),
//           child: Column(
//             children: listItems.map((n) {
//               return ExperienceNewsCard(
//                 news: n,
//                 onTap: () => _openDetail(context, n),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
