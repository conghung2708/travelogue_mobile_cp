import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/tour/tour_bloc.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour/screens/tour_detail_screen.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_header.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_mansory_grid.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_search_delegate.dart';
import 'package:travelogue_mobile/representation/tour/widgets/tour_search_field.dart';
import 'package:travelogue_mobile/representation/tour/widgets/trip_plan_banner.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/motivation_banner.dart';

const Map<int, String> kTourTypeOptions = {
  1: 'Du lịch nghỉ dưỡng',
  2: 'Du lịch khám phá',
  3: 'Du lịch sinh thái',
  4: 'Du lịch văn hoá',
  5: 'Du lịch tâm linh',
  6: 'Du lịch ẩm thực',
  7: 'Du lịch mạo hiểm',
};

class TourScreen extends StatefulWidget {
  const TourScreen({super.key});
  static const String routeName = '/tour';

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  final Set<int> _selectedTypes = {};

  Future<void> _openSearch(List<TourModel> tours) async {
    final picked = await showSearch<TourModel?>(
      context: context,
      delegate: TourSearchDelegate(_applyFilters(tours)),
    );
    if (picked != null) {
      final cover =
          (picked.medias.isNotEmpty ? (picked.medias.first.mediaUrl ?? '') : '')
              .trim();
      final heroImage =
          cover.isNotEmpty ? cover : AssetHelper.img_tay_ninh_login;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TourDetailScreen(
            tour: picked,
            image: heroImage,
            isBooked: false,
            showGuideTab: false,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<TourBloc>().add(const GetAllToursEvent());
  }

  bool matches(String text, String query) {
    final normalizedText = removeDiacritics(text).toLowerCase();
    final normalizedQuery = removeDiacritics(query).toLowerCase();
    return normalizedText.contains(normalizedQuery);
  }

  List<TourModel> _applyFilters(List<TourModel> input) {
    if (_selectedTypes.isEmpty) return input;
    return input.where((t) {
      final tt = t.tourType;
      return tt != null && _selectedTypes.contains(tt);
    }).toList();
  }

  Future<void> _openFilterSheet() async {
    final tmp = Set<int>.of(_selectedTypes);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
            top: 12,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.tune),
                  const SizedBox(width: 8),
                  const Text('Lọc theo loại tour',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      tmp.clear();
                      setState(() {});
                    },
                    child: const Text('Xoá lọc'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: kTourTypeOptions.entries.map((e) {
                    final checked = tmp.contains(e.key);
                    return CheckboxListTile(
                      value: checked,
                      onChanged: (v) {
                        if (v == true) {
                          tmp.add(e.key);
                        } else {
                          tmp.remove(e.key);
                        }
                        (ctx as Element).markNeedsBuild();
                      },
                      title: Text(e.value),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedTypes
                        ..clear()
                        ..addAll(tmp);
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Áp dụng'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    context.read<TourBloc>().add(const GetAllToursEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: TourHeader()),
                  const SizedBox(width: 8),
                  Badge.count(
                    count: _selectedTypes.length,
                    isLabelVisible: _selectedTypes.isNotEmpty,
                    child: IconButton(
                      tooltip: 'Lọc theo loại tour',
                      onPressed: _openFilterSheet,
                      icon: const Icon(Icons.tune_rounded),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.5.h),
              BlocBuilder<TourBloc, TourState>(
                buildWhen: (p, c) => c is GetToursSuccess || c is TourLoading,
                builder: (context, state) {
                  final tours = state is GetToursSuccess
                      ? _applyFilters(state.tours)
                      : <TourModel>[];
                  final enabled = state is GetToursSuccess && tours.isNotEmpty;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: enabled ? () => _openSearch(tours) : null,
                        child: AbsorbPointer(
                            child: TourSearchField(onChanged: (_) {})),
                      ),
                      if (_selectedTypes.isNotEmpty) ...[
                        SizedBox(height: 1.h),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._selectedTypes.map((id) => InputChip(
                                  label: Text(kTourTypeOptions[id] ?? 'Loại $id'),
                                  onDeleted: () =>
                                      setState(() => _selectedTypes.remove(id)),
                                )),
                            TextButton.icon(
                              onPressed: () => setState(_selectedTypes.clear),
                              icon: const Icon(Icons.close),
                              label: const Text('Xoá tất cả'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
              SizedBox(height: 3.h),
              const MotivationBanner(),
              SizedBox(height: 3.h),
              const TitleWithCustoneUnderline(
                  text: "Tour tại ", text2: "Tây Ninh"),
              SizedBox(height: 2.h),
              Expanded(
                child: BlocBuilder<TourBloc, TourState>(
                  builder: (context, state) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: () {
                        if (state is TourLoading) {
                          return ListView(
                            physics:
                                const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            ],
                          );
                        } else if (state is GetToursSuccess) {
                          final filtered = _applyFilters(state.tours);
                          if (filtered.isEmpty) {
                            return ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(
                                    height: 200,
                                    child: Center(
                                        child: Text(
                                            'Không có tour phù hợp bộ lọc.'))),
                              ],
                            );
                          }
                          return TourMasonryGrid(tours: filtered);
                        } else if (state is TourError) {
                          return ListView(
                            physics:
                                const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 200,
                                child: Center(child: Text(state.message)),
                              ),
                            ],
                          );
                        }
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [SizedBox(height: 200)],
                        );
                      }(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
