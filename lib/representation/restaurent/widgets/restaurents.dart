import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_bloc.dart';
import 'package:travelogue_mobile/core/blocs/nearest_data/nearest_data_state.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/representation/restaurent/widgets/restaurant_card.dart';

class Restaurents extends StatelessWidget {
  const Restaurents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearestDataBloc, NearestDataState>(
      builder: (context, state) {
        if (state is NearestCuisineLoaded) {
          final List<LocationModel> restaurants = state.cuisines;

          if (restaurants.isEmpty) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionTitle(
                Icons.restaurant,
                "Ẩm thực địa phương",
                Colors.orange,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return RestaurantCard(
                        locationModel: restaurants[index],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemCount: restaurants.length,
                  ),
                ),
              ),
              SizedBox(height: 20.sp),
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
