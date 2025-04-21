import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travelogue_mobile/core/blocs/festival/festival_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';
import 'package:travelogue_mobile/core/utils/image_network_card.dart';
import 'package:travelogue_mobile/data/data_local/user_local.dart';
import 'package:travelogue_mobile/model/event_model.dart';
import 'package:travelogue_mobile/model/month_model.dart';
import 'package:travelogue_mobile/representation/event/widgets/arrow_back_button.dart';
import 'package:travelogue_mobile/representation/festival/screens/festival_detail_screen.dart';
import 'package:travelogue_mobile/representation/festival/widgets/festival_screen_background.dart';
import 'package:travelogue_mobile/representation/festival/widgets/month_widget.dart';

class FestivalScreen extends StatelessWidget {
  static const routeName = '/festival_screen';

  const FestivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FestivalBloc, FestivalState>(
        builder: (context, state) {
          final List<EventModel> festivals = state.props[0] as List<EventModel>;
          int monthCurrent = state.props[1] as int;
          return Stack(
            children: [
              Container(color: Colors.white),
              FestivalScreenBackground(
                screenHeight: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          /// Nút Back
                          ArrowBackButton(onPressed: () {
                            Navigator.of(context).pop();
                          }),

                          const Expanded(
                            child: Text(
                              "Lễ hội & Sự kiện",
                              style: TextStyle(
                                fontFamily: "Pattaya",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (UserLocal().getAccessToken.isNotEmpty)

                            /// Avatar người dùng
                            DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: ImageHelper.loadFromAsset(
                                  AssetHelper.img_avatar,
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: months
                            .map((month) => MonthWidget(
                                  month: month,
                                  isSelected: monthCurrent == month.monthId,
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: festivals.isEmpty
                          ? _pageEmpty(context, monthCurrent)
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              itemCount: festivals.length,
                              itemBuilder: (context, index) {
                                final festival = festivals[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      FestivalDetailScreen.routeName,
                                      arguments: festival,
                                    );
                                  },
                                  child: FestivalCard(festival: festival),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _pageEmpty(BuildContext context, int monthCurrent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageHelper.loadFromAsset(
            AssetHelper.img_search_not_found,
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            "Không tìm thấy sự kiện lễ hội trong tháng $monthCurrent",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class FestivalCard extends StatelessWidget {
  final EventModel festival;

  const FestivalCard({super.key, required this.festival});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.3),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Ảnh sự kiện
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ImageNetworkCard(
                url: festival.imgUrlFirst,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // Tiêu đề
            Text(
              festival.name ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50), // Xanh đậm sang trọng
              ),
            ),
            const SizedBox(height: 6),

            // Mô tả ngắn gọn
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    festival.description ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ngày diễn ra lễ hội
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.date_range,
                        color: Colors.blueAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(festival.startDate ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "đến",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Row(
                  children: [
                    const Icon(Icons.event_available,
                        color: Colors.green, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(festival.endDate ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}
