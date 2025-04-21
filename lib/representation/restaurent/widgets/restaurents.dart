import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/hotel_restaurent/hotel_restaurant_bloc.dart';
import 'package:travelogue_mobile/model/restaurant_model.dart';
import 'package:travelogue_mobile/representation/restaurent/widgets/restaurant_card.dart';

class Restaurents extends StatelessWidget {
  const Restaurents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelRestaurantBloc, HotelRestaurantState>(
      builder: (context, state) {
        final List<RestaurantModel> restaurants =
            state.props[1] as List<RestaurantModel>;

        return restaurants.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle(
                    Icons.restaurant,
                    "Quán ăn gợi ý",
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
                              restaurantModel: restaurants[index]);
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
