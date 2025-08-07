import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_bloc.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_state.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/hotel/widgets/hotel_card.dart';

class Hotels extends StatelessWidget {
  const Hotels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearestDataBloc, NearestDataState>(
      builder: (context, state) {
        if (state is NearestHistoricalLoaded) {
          final List<LocationModel> historicalPlaces = state.historicals;

          if (historicalPlaces.isEmpty) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionTitle(
                Icons.museum,
                "Di tích lịch sử gần bạn",
                Colors.brown,
              ),
              Container(
                height: 200,
                margin: const EdgeInsets.only(top: 10),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final location = historicalPlaces[index];
                    return HotelCard(
                      locationModel: location,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemCount: historicalPlaces.length,
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.symmetric(horizontal: 12.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
