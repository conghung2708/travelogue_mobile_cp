import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';

class PlaceAppBar extends StatelessWidget {
  const PlaceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(30),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.all(kItemPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kDefaultPadding,
                ),
              ),
            ),
            child: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
