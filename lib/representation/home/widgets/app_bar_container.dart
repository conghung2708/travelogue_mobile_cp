import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';

class AppBarContainerWidget extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final String? titleString;
  final bool implementLeading;
  final bool implementTraling;

  const AppBarContainerWidget(
      {super.key,
      required this.child,
      this.title,
      this.titleString,
      this.implementLeading = false,
      this.implementTraling = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
          child: AppBar(
            centerTitle: true,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.blue),
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 150,
            // backgroundColor: ColorPalette.backgroundScaffoldColor,
            title: title ??
                Row(
                  children: [
                    if (implementLeading)
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(kDefaultPadding)),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(kItemPadding),
                        child: const Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.black,
                          size: kDefaultIconSize,
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              titleString ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (implementTraling)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            kDefaultPadding,
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(kItemPadding),
                        child: const Icon(
                          FontAwesomeIcons.bars,
                          size: kDefaultIconSize,
                          color: Colors.black,
                        ),
                      )
                  ],
                ),
            flexibleSpace: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: Gradients.defaultGradientBackground,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          35,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 220),
          child: child,
        )
      ],
    );
  }
}
