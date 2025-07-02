import 'package:travelogue_mobile/core/helpers/asset_helper.dart';

class TourMediaTestModel {
  final String id;
  final String? mediaUrl;
  final String? fileName;
  final String? fileType;
  final int? sizeInBytes;
  final bool? isThumbnail;
  final String? tourId;

  TourMediaTestModel({
    required this.id,
    this.mediaUrl,
    this.fileName,
    this.fileType,
    this.sizeInBytes,
    this.isThumbnail,
    this.tourId,
  });
}


final List<TourMediaTestModel> mockTourMedia = [
  TourMediaTestModel(
    id: 'tourMedia1',
    mediaUrl:   
    AssetHelper.img_ex_ba_den_1,
    tourId: 'tour1',
  ),
    TourMediaTestModel(
    id: 'tourMedia2',
    mediaUrl:   
    AssetHelper.img_thap_01,
    tourId: 'tour2',
  ),
];
