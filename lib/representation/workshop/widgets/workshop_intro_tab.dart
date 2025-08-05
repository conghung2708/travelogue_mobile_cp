import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/workshop/workshop_detail_model.dart';

class WorkshopIntroTab extends StatefulWidget {
  final WorkshopDetailModel workshop;

  const WorkshopIntroTab({
    super.key,
    required this.workshop,
  });

  @override
  State<WorkshopIntroTab> createState() => _WorkshopIntroTabState();
}

class _WorkshopIntroTabState extends State<WorkshopIntroTab> {
  int _page = 0;
  late final List<String> images;

  @override
  void initState() {
    super.initState();
    images = []; 
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 22.h,
                child: PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _buildImage(images[i]),
                ),
              ),
            ),
            SizedBox(height: .8.h),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  images.length,
                  (i) => Container(
                    margin: EdgeInsets.symmetric(horizontal: .6.w),
                    width: i == _page ? 8 : 6,
                    height: i == _page ? 8 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page ? Colors.blue : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // Mô tả ngắn
          if (widget.workshop.description != null &&
              widget.workshop.description!.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                widget.workshop.description!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),

 
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: MarkdownBody(
                data: (widget.workshop.content != null &&
                        widget.workshop.content!.trim().isNotEmpty)
                    ? widget.workshop.content!
                    : '_Chưa có mô tả chi tiết_',
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  h1: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  h2: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  h3: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          if (widget.workshop.craftVillageName != null)
            _buildContactCard(widget.workshop.craftVillageName!),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    final isNetwork = path.startsWith('http');
    return isNetwork
        ? Image.network(path, fit: BoxFit.cover)
        : Image.asset(path, fit: BoxFit.cover);
  }

  Widget _buildContactCard(String villageName) => Card(
        color: Colors.blue.shade50,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Làng nghề',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700)),
              SizedBox(height: 1.5.h),
              Text(
                villageName,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
}
