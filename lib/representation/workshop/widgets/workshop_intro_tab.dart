import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sizer/sizer.dart';

import 'package:travelogue_mobile/model/craft_village/workshop_test_model.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';


class WorkshopIntroTab extends StatefulWidget {
  final WorkshopTestModel workshop;
  final CraftVillageModel? village;

  const WorkshopIntroTab({
    super.key,
    required this.workshop,
    this.village,
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
    images = widget.workshop.imageList;
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
                    : '_Chưa có mô tả_',
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

        
          if (widget.village != null) _buildContactCard(widget.village!),
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

  
  Widget _buildContactCard(CraftVillageModel village) => Card(
        color: Colors.blue.shade50,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Liên hệ làng nghề',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700)),
              SizedBox(height: 2.h),
              _ContactRow(icon: Icons.phone, text: village.phoneNumber ?? ''),
              _ContactRow(icon: Icons.email_rounded, text: village.email ?? ''),
              if (village.website != null)
                _ContactRow(icon: Icons.language_rounded, text: village.website!),
              if (village.address != null)
                _ContactRow(icon: Icons.location_on_rounded, text: village.address!),
            ],
          ),
        ),
      );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.2.h),
      child: Row(
        children: [
          SizedBox(
            width: 20.sp,
            child: Icon(icon, size: 16.sp, color: Colors.blue),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}