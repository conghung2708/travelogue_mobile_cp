// lib/representation/tour_guide/screens/tour_guide_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/app_sync/app_sync.dart';

import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_bloc.dart';
import 'package:travelogue_mobile/core/blocs/tour_guide/tour_guide_event.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_model.dart';
import 'package:travelogue_mobile/representation/home/widgets/title_widget.dart';
import 'package:travelogue_mobile/representation/tour_guide/screens/guide_team_selector_screen.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/confirm_booking_dialog.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/tour_guide_card.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/filter_guide_sheet.dart';
import 'package:travelogue_mobile/representation/auth/screens/login_screen.dart';
import 'package:travelogue_mobile/core/helpers/auth_helper.dart';
import 'package:travelogue_mobile/core/repository/tour_guide_repository.dart';

import 'package:travelogue_mobile/representation/tour_guide/widgets/guide_greeting_header.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/motivation_banner.dart';
import 'package:travelogue_mobile/representation/tour_guide/widgets/guide_top_bar.dart';

class TourGuideScreen extends StatefulWidget {
  const TourGuideScreen({super.key});
  static const String routeName = '/tour-guides';

  @override
  State<TourGuideScreen> createState() => _TourGuideScreenState();
}

class _TourGuideScreenState extends State<TourGuideScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  final _repo = TourGuideRepository();

  @override
  void initState() {
    super.initState();

    if (AppSync.instance.refreshGuides) {
      if (_startDate != null || _endDate != null) {
        context.read<TourGuideBloc>().add(
          FilterTourGuideEvent(
            TourGuideFilterModel(startDate: _startDate, endDate: _endDate),
          ),
        );
      } else {
        context.read<TourGuideBloc>().add(const GetAllTourGuidesEvent());
      }
      AppSync.instance.refreshGuides = false; // reset cờ
    } else {
    
      context.read<TourGuideBloc>().add(const GetAllTourGuidesEvent());
    }
  }

  Future<void> _reloadGuides() async {
    if (_startDate != null || _endDate != null) {
      context.read<TourGuideBloc>().add(
        FilterTourGuideEvent(
          TourGuideFilterModel(startDate: _startDate, endDate: _endDate),
        ),
      );
    } else {
      context.read<TourGuideBloc>().add(const GetAllTourGuidesEvent());
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (_) => FilterGuideSheet(
        initialStartDate: _startDate,
        initialEndDate: _endDate,
        onApplyFilter: (TourGuideFilterModel filter) {
          setState(() {
            _startDate = filter.startDate;
            _endDate = filter.endDate;
          });
          context.read<TourGuideBloc>().add(FilterTourGuideEvent(filter));
        },
      ),
    );
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      locale: const Locale('vi', 'VN'),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked == null) return;

    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
    });

    context.read<TourGuideBloc>().add(
      FilterTourGuideEvent(
        TourGuideFilterModel(
          startDate: _startDate,
          endDate: _endDate,
        ),
      ),
    );
  }

  void _clearRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    context.read<TourGuideBloc>().add(const GetAllTourGuidesEvent());
  }

  Future<void> _onBookNow(TourGuideModel guide) async {
    if (_startDate == null || _endDate == null) {
      await _pickRange();
      if (_startDate == null || _endDate == null) return;
    }

    final guideKey = guide.id ?? guide.id ?? '';
    if (guideKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thiếu mã HDV.')),
      );
      return;
    }

    final ok = await _repo.isAvailableUsingFilter(
      guideId: guideKey,
      start: _startDate!,
      end: _endDate!,
    );

    if (ok) {
      _goToTeamSelector(guide);
      return;
    }

    final suggestions = await _repo.suggestNearestAvailabilityUsingFilter(
      guideId: guideKey,
      from: _startDate!,
      to: _endDate!,
      limit: 4,
    );

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _GuideBusySheet(
        guide: guide,
        currentRange: DateTimeRange(start: _startDate!, end: _endDate!),
        suggestions: suggestions,
        onUseSuggestion: (r) {
          Navigator.pop(context);
          setState(() {
            _startDate = r.start;
            _endDate = r.end;
          });
          _goToTeamSelector(guide);
        },
        onSeeAvailableGuides: () {
          Navigator.pop(context);
          context.read<TourGuideBloc>().add(
            FilterTourGuideEvent(
              TourGuideFilterModel(startDate: _startDate, endDate: _endDate),
            ),
          );
        },
        onPickAnotherDate: () async {
          Navigator.pop(context);
          await _pickRange();
          if (_startDate != null && _endDate != null) {
            _onBookNow(guide);
          }
        },
      ),
    );
  }

  void _goToTeamSelector(TourGuideModel guide) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuideTeamSelectorScreen(
          guide: guide,
          startDate: _startDate!,
          endDate: _endDate!,
          unitPrice: guide.price ?? 0,
        ),
      ),
    );
  }

  void _confirmBooking(TourGuideModel guide) async {
    if (!isLoggedIn()) {
      Navigator.pushNamed(
        context,
        LoginScreen.routeName,
        arguments: {'redirectRoute': TourGuideScreen.routeName},
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmBookingDialog(guide: guide),
    );

    if (ok == true) {
      _onBookNow(guide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 2.h,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GuideGreetingHeader(),
              SizedBox(height: 3.h),
              const MotivationBanner(),
              SizedBox(height: 2.h),
              const TitleWithCustoneUnderline(text: "Các hướng dẫn ", text2: "viên"),
              SizedBox(height: 1.2.h),
              GuideTopBar(
                onOpenFilter: _openFilterSheet,
                onPickDateRange: _pickRange,
                onClearDate: (_startDate != null && _endDate != null) ? _clearRange : null,
                startDate: _startDate,
                endDate: _endDate,
                color: ColorPalette.primaryColor,
              ),

              Expanded(
                child: BlocBuilder<TourGuideBloc, TourGuideState>(
                  builder: (context, state) {
                 
                    return RefreshIndicator.adaptive(
                      color: ColorPalette.primaryColor,
                      onRefresh: _reloadGuides,
                      child: () {
                        if (state is TourGuideLoading) {
                    
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            children: const [
                              SizedBox(height: 180),
                              Center(child: CircularProgressIndicator()),
                              SizedBox(height: 240),
                            ],
                          );
                        }

                        if (state is TourGuideLoaded) {
                          final guides = state.guides;
                          if (guides.isEmpty) {
                         
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(top: 8.h),
                              children: [
                                Center(
                                  child: Text(
                                    (_startDate != null && _endDate != null)
                                        ? 'Không có HDV phù hợp trong khoảng ngày đã chọn.'
                                        : 'Không có HDV nào.',
                                  ),
                                ),
                                SizedBox(height: 40.h),
                              ],
                            );
                          }

                          return MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2.h,
                            crossAxisSpacing: 4.w,
                            itemCount: guides.length,
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, i) => Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: TourGuideCard(
                                guide: guides[i],
                                onBookNow: () => _confirmBooking(guides[i]),
                              ),
                            ),
                          );
                        }

                        if (state is TourGuideError) {
                         
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: EdgeInsets.only(top: 8.h),
                            children: [
                              Center(child: Text(state.message)),
                              SizedBox(height: 2.h),
                              Center(
                                child: OutlinedButton.icon(
                                  onPressed: _reloadGuides,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Thử lại'),
                                ),
                              ),
                              SizedBox(height: 40.h),
                            ],
                          );
                        }

                        
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: const [SizedBox(height: 300)],
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

class _GuideBusySheet extends StatelessWidget {
  final TourGuideModel guide;
  final DateTimeRange currentRange;
  final List<DateTimeRange> suggestions;
  final void Function(DateTimeRange) onUseSuggestion;
  final VoidCallback onSeeAvailableGuides;
  final Future<void> Function() onPickAnotherDate;

  const _GuideBusySheet({
    required this.guide,
    required this.currentRange,
    required this.suggestions,
    required this.onUseSuggestion,
    required this.onSeeAvailableGuides,
    required this.onPickAnotherDate,
  });

  String _fmtShort(DateTime d) => DateFormat('dd/MM').format(d);

  String _rangeLabel(DateTimeRange r) {
    return '${_fmtShort(r.start)} → ${_fmtShort(r.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: cs.error.withOpacity(.10),
                  child: Icon(Icons.event_busy_rounded, color: cs.error),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HDV bận trong khoảng đã chọn',
                          style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        '${_fmtShort(currentRange.start)} → ${_fmtShort(currentRange.end)}',
                        style: text.bodySmall?.copyWith(color: cs.outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Current range card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surfaceVariant.withOpacity(.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _rangeLabel(currentRange),
                      style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: cs.outlineVariant.withOpacity(.6)),
            const SizedBox(height: 12),

            // Suggestions
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Gợi ý ngày gần nhất:', style: text.labelLarge),
            ),
            const SizedBox(height: 8),
            if (suggestions.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions.map((r) {
                  return _SuggestionChip(
                    label: '${_fmtShort(r.start)} → ${_fmtShort(r.end)}',
                    onTap: () => onUseSuggestion(r),
                  );
                }).toList(),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.surfaceVariant.withOpacity(.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: cs.outline),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Không có gợi ý gần. Bạn có thể xem HDV khác hoặc chọn khoảng ngày khác.',
                        style: text.bodySmall?.copyWith(color: cs.outline),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Primary action
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.search_rounded),
                onPressed: onSeeAvailableGuides,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                label: const Text('Xem HDV rảnh trong khoảng này'),
              ),
            ),
            const SizedBox(height: 10),

            // Secondary action
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.date_range_rounded),
                onPressed: onPickAnotherDate,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                label: const Text('Chọn khoảng ngày khác'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(.35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, size: 16, color: cs.primary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}
