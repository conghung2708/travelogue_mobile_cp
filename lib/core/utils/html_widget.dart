// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/helpers/string_helper.dart';

class HtmlWidget extends StatelessWidget {
  final String text;
  final int? maxLines;
  const HtmlWidget({
    super.key,
    required this.text,
    this.maxLines,
  });

  dom.Document get _document {
    // final dom.Document documentHtml = htmlparser.parse(text.removeEmptyLines);

    String textHtml = text.removeEmptyLines;

    // final List<dom.Element?> divTags = documentHtml.querySelectorAll('div');
    // for (final dom.Element? divTag in divTags) {
    //   if (divTag != null && !listCategoryId.contains(divTag.attributes['id'])) {
    //     textHtml = textHtml.replaceAll(divTag.outerHtml, '');
    //   }
    // }

    final dom.Document documentNew =
        htmlparser.parse(textHtml.removeEmptyLines);

    return documentNew;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Html.fromDom(
        document: _document,
        shrinkWrap: true,
        style: {
          '#': Style(
            maxLines: maxLines,
            textOverflow: maxLines == null ? null : TextOverflow.fade,
            height:
                maxLines == null ? Height.auto() : Height(20.sp * maxLines!),
            color: Theme.of(context).textTheme.bodyMedium!.color,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            textDecorationColor: Theme.of(context).focusColor,
          ),
          'img': Style(
            height: maxLines == null ? Height.auto() : Height(0),
          ),
          'body': Style(
            padding: HtmlPaddings.zero,
            margin: Margins(
              bottom: Margin.zero(),
              left: Margin.zero(),
              top: Margin.zero(),
              right: Margin.zero(),
            ),
            fontSize: FontSize(17.sp),
            textAlign: TextAlign.justify,
            color: Theme.of(context).textTheme.bodyMedium!.color,
            textDecorationColor: Theme.of(context).focusColor,
          ),
          'a': Style(
            color: Theme.of(context).focusColor,
            textDecoration: TextDecoration.underline,
            textDecorationColor: Theme.of(context).focusColor,
          ),
          'span': Style(
            padding: HtmlPaddings.zero,
            margin: Margins(
              bottom: Margin.zero(),
              left: Margin.zero(),
              top: Margin.zero(),
              right: Margin.zero(),
            ),
            fontSize: FontSize(17.sp),
            textDecorationColor: Theme.of(context).focusColor,
          ),
          'p': Style(
            padding: HtmlPaddings.zero,
            margin: Margins(
              bottom: Margin.zero(),
              left: Margin.zero(),
              top: Margin.zero(),
              right: Margin.zero(),
            ),
            fontSize: FontSize(17.sp),
            textAlign: TextAlign.justify,
            textDecorationColor: Theme.of(context).focusColor,
          ),
        },
        onLinkTap: (url, attributes, element) {
          // if (url != null) {
          //   UrlLauncherHelper.launchUrlCustom(
          //     url,
          //   );
          // }
        },
      ),
    );
  }
}
