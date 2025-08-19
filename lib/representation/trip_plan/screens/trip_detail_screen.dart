import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/trip_plan/trip_plan_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/trip_plan/trip_plan_detail_model.dart';
import 'package:travelogue_mobile/representation/trip_plan/widgets/trip_detail_content.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  static const routeName = '/trip_detail';

  List<DateTime> _getTripDays(DateTime start, DateTime end) => List.generate(
        end.difference(start).inDays + 1,
        (i) => start.add(Duration(days: i)),
      );

  @override
  Widget build(BuildContext context) {
    final String? tripId =
        ModalRoute.of(context)?.settings.arguments as String?;
    if (tripId == null || tripId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("❌ Không có ID chuyến đi")),
      );
    }

    return BlocProvider(
      create: (_) => TripPlanBloc()..add(GetTripPlanDetailEvent(tripId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<TripPlanBloc, TripPlanState>(
            builder: (context, state) {
              if (state is TripPlanLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TripPlanError) {
                return Center(child: Text(state.message));
              } else if (state is GetTripPlanDetailSuccess) {
                final TripPlanDetailModel trip = state.tripPlanDetail;
                final days = _getTripDays(trip.startDate, trip.endDate);
                final currencyFormat =
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

                return Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          trip.days.isNotEmpty &&
                                  trip.days.first.activities.isNotEmpty
                              ? (trip.days.first.activities.first.imageUrl ??
                                  AssetHelper.img_default)
                              : AssetHelper.img_default,
                          width: double.infinity,
                          height: 30.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AssetHelper.img_default,
                            width: double.infinity,
                            height: 30.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2.h,
                          left: 4.w,
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: TripDetailContent(
                          trip: trip,
                          currencyFormat: currencyFormat,
                        ),
                      ),
                    )
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            final bool confirm = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Xác nhận'),
                content:
                    const Text('Bạn có muốn gọi điện cho 0336626193 không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Huỷ'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Gọi'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              final Uri phoneUri = Uri(scheme: 'tel', path: '0336626193');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Không thể thực hiện cuộc gọi.')),
                );
              }
            }
          },
          child: const Icon(Icons.phone),
        ),
      ),
    );
  }
}
