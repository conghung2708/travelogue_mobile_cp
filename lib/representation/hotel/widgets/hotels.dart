import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/hotel_restaurent/hotel_restaurant_bloc.dart';
import 'package:travelogue_mobile/model/hotel_model.dart';
import 'package:travelogue_mobile/representation/hotel/widgets/hotel_card.dart';

class Hotels extends StatelessWidget {
  const Hotels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelRestaurantBloc, HotelRestaurantState>(
      builder: (context, state) {
        final List<HotelModel> listHotel = state.props[0] as List<HotelModel>;

        return listHotel.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionTitle(
                    Icons.hotel,
                    "Khách sạn gợi ý",
                    Colors.blue,
                  ),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return HotelCard(hotelModel: listHotel[index]);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemCount: listHotel.length,
                    ),
                  ),
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
