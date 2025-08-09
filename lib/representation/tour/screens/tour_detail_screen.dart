import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_detail_content.dart';
import 'package:travelogue_mobile/core/repository/tour_repository.dart';

class TourDetailScreen extends StatefulWidget {
  static const routeName = '/tour_detail';

  final TourModel tour; 
  final String image;
  final bool readOnly;
  final DateTime? startTime;
  final bool? isBooked;

  const TourDetailScreen({
    super.key,
    required this.tour,
    required this.image,
    this.readOnly = false,
    this.startTime,
    this.isBooked = false,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  late Future<TourModel?> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = TourRepository().getTourById(widget.tour.tourId!);
  }

  @override
  Widget build(BuildContext context) {
    final isAsset = widget.image.startsWith('assets/');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                isAsset
                    ? Image.asset(
                        widget.image,
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.image,
                        width: double.infinity,
                        height: 30.h,
                        fit: BoxFit.cover,
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
              child: FutureBuilder<TourModel?>(
                future: _futureDetail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Lỗi tải tour chi tiết: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('Không tìm thấy tour.'));
                  }

                  final tour = snapshot.data!;

                  // ✅ Debug log
                  print('[TourDetailScreen] tourId: ${tour.tourId}');
                  print(
                      '[TourDetailScreen] schedules: ${tour.schedules?.length}');
                  print(
                      '[TourDetailScreen] guide: ${tour.tourGuide?.userName}');

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: TourDetailContent(
                      tour: tour,
                      guide: tour.tourGuide,
                      readOnly: widget.readOnly,
                      startTime: widget.startTime,
                      isBooked: widget.isBooked,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.readOnly
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Xác nhận"),
                    content: const Text(
                        "Bạn có muốn gọi điện cho 0336626193 không?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Huỷ"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Gọi"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  final phoneUri = Uri(scheme: 'tel', path: '0336626193');
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
    );
  }
}
