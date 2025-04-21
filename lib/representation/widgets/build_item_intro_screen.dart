import 'package:flutter/material.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/constants/textstyle_constants.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';

class BuildItemIntroScreen extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final AlignmentGeometry alignmentGeometry;

  const BuildItemIntroScreen(
      {super.key,
        required this.image,
        required this.title,
        required this.description,
        required this.alignmentGeometry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image with rounded corners and shadow
        Container(
          alignment: alignmentGeometry,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Rounded corners for image
            child: ImageHelper.loadFromAsset(
              image,
              height: 350,
              width: 370,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: kMediumPadding,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Semi-transparent background
              borderRadius: BorderRadius.circular(20), // Rounded corners for container
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 4), // Shadow offset
                ),
              ],
            ),
            padding: const EdgeInsets.all(kMediumPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.captionStyle.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: kMediumPadding,
                ),
                Text(
                  description,
                  style: TextStyles.defaultStyle.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
