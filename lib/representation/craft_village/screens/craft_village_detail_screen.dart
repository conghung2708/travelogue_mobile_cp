// lib/representation/craft_village/screens/craft_village_detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:travelogue_mobile/core/blocs/location/location_bloc.dart';
import 'package:travelogue_mobile/core/blocs/location/location_event.dart';
import 'package:travelogue_mobile/core/blocs/location/location_state.dart';

import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/craft_village/craft_village_model.dart';

import 'package:travelogue_mobile/representation/craft_village/widgets/craft_village_section.dart';
import 'package:travelogue_mobile/representation/widgets/image_grid_preview.dart';

class CraftVillageDetailScreen extends StatefulWidget {
  const CraftVillageDetailScreen({super.key});
  static const routeName = '/craft_village_detail';

  @override
  State<CraftVillageDetailScreen> createState() =>
      _CraftVillageDetailScreenState();
}

class _CraftVillageDetailScreenState extends State<CraftVillageDetailScreen>
    with TickerProviderStateMixin {
  LocationModel? _initial;
  String? _id;
  late final TabController _tabController;

  static const double _kTabBarHeight = 56.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is LocationModel) {
      _initial = args;
      final cover =
          _initial!.listImages.isNotEmpty ? _initial!.listImages.first : null;
      if (cover != null) {
        precacheImage(CachedNetworkImageProvider(cover), context);
      }
    } else if (args is String) {
      _id = args;
      context.read<LocationBloc>().add(LocationDetailRequested(_id!));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SliverAppBar _sliverHeader(LocationModel loc) {
    final cover = loc.listImages.isNotEmpty ? loc.listImages.first : null;
    final title = (loc.name ?? '').trim();

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 32.h,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: _roundIconBtn(
        context,
        icon: Icons.arrow_back_rounded,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        if ((loc.districtName ?? '').isNotEmpty)
          _glassChip(
            icon: Icons.place_outlined,
            text: loc.districtName!,
            dense: true,
          ),
        const SizedBox(width: 10),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (_, c) {
          final t =
              ((c.biggest.height - kToolbarHeight) / (32.h - kToolbarHeight))
                  .clamp(0.0, 1.0);
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsetsDirectional.only(
                start: 16, bottom: 12, end: 16),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: t < 0.35 ? 1 : 0,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (cover != null)
                  Hero(
                    tag: 'cover-$title',
                    child: LayoutBuilder(
                      builder: (ctx, _) {
                        final mq = MediaQuery.of(ctx);
                        final targetW =
                            (mq.size.width * mq.devicePixelRatio).round();
                        return CachedNetworkImage(
                          imageUrl: cover,
                          fit: BoxFit.cover,
                          memCacheWidth: targetW,
                          placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          errorWidget: (_, __, ___) =>
                              Container(color: Colors.grey.shade300),
                          fadeInDuration: const Duration(milliseconds: 120),
                          fadeOutDuration: const Duration(milliseconds: 80),
                        );
                      },
                    ),
                  )
                else
                  Container(color: Colors.grey.shade300),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16.0 + _kTabBarHeight,
                  child: _glassBlock(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _glassChip(
                          icon: Icons.category_outlined,
                          text: (loc.category ?? 'Địa điểm'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_kTabBarHeight),
        child: _fancyTabBar(_tabController),
      ),
    );
  }

  Widget _introTab(LocationModel loc) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
          sliver: SliverList.list(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // if (loc.minPrice != null || loc.maxPrice != null)
                  //   _infoPill(Icons.price_change_outlined, _priceRange(loc)),
                  if ((loc.openTime ?? '').isNotEmpty ||
                      (loc.closeTime ?? '').isNotEmpty)
                    _infoPill(Icons.schedule_rounded,
                        '${loc.openTime ?? '—'} – ${loc.closeTime ?? '—'}'),
                  if ((loc.address ?? '').isNotEmpty)
                    _infoPill(Icons.place_outlined, loc.address!),
                ],
              ),
              SizedBox(height: 1.6.h),
              if ((loc.content ?? '').isNotEmpty)
                _sectionCard(
                  title: 'Giới thiệu',
                  child: Html(
                    data: loc.content!,
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(13.sp),
                        color: Colors.black87,
                        lineHeight: const LineHeight(1.45),
                        textAlign: TextAlign.justify,
                      ),
                      "p": Style(margin: Margins.only(bottom: 10)),
                      "h1": Style(
                          fontSize: FontSize(16.sp),
                          fontWeight: FontWeight.w800),
                      "h2": Style(
                          fontSize: FontSize(14.sp),
                          fontWeight: FontWeight.w800),
                      "img": Style(margin: Margins.only(bottom: 8)),
                    },
                  ),
                ),
              if (loc.listImages.isNotEmpty) ...[
                _sectionHeader('Hình ảnh', icon: Icons.photo_library_outlined),
                SizedBox(height: .8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ImageGridPreview(images: loc.listImages, maxImages: 6),
                ),
              ],
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _craftVillageTab(LocationModel loc) {
    final CraftVillageModel? cv = loc.craftVillage;
    if (cv == null) {
      return const Center(child: Text('Không có thông tin làng nghề.'));
    }
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
          sliver: SliverList.list(
            children: [
              CraftVillageSection.fromCraftVillage(
                craftVillage: cv,
                padding: EdgeInsets.zero,
              ),
              if (cv.workshop != null) ...[
                SizedBox(height: 1.6.h),
                _sectionHeader('Trải nghiệm làng nghề',
                    icon: Icons.handyman_outlined),
                SizedBox(height: .8.h),
                WorkshopPreviewCard(workshop: cv.workshop!),
              ],
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initial != null) {
      return _ModernScaffold(
        slivers: [
          _sliverHeader(_initial!),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                Builder(builder: (_) => _introTab(_initial!)),
                Builder(builder: (_) => _craftVillageTab(_initial!)),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: _bgColor(context),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading || state is LocationInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LocationFailure) {
            return Center(child: Text(state.message));
          }
          if (state is LocationEmpty) {
            return const Center(child: Text('Không có dữ liệu.'));
          }
          if (state is LocationDetailSuccess) {
            final loc = state.location;
            final cover =
                loc.listImages.isNotEmpty ? loc.listImages.first : null;
            if (cover != null) {
              precacheImage(CachedNetworkImageProvider(cover), context);
            }
            return _ModernScaffold(
              slivers: [
                _sliverHeader(loc),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Builder(builder: (_) => _introTab(loc)),
                      Builder(builder: (_) => _craftVillageTab(loc)),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _bgColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface.withOpacity(.98);

  Widget _sectionHeader(String text, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: Gradients.defaultGradientBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
        if (icon != null) const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w900,
            color: ColorPalette.text1Color,
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5.sp)),
          SizedBox(height: .8.h),
          child
        ],
      ),
    );
  }

  Widget _roundIconBtn(BuildContext ctx,
      {required IconData icon, double size = 42, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: Gradients.defaultGradientBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 12,
              )
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _glassBlock({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(.25)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _glassChip({
    required IconData icon,
    required String text,
    bool dense = false,
  }) {
    final maxW = MediaQuery.of(context).size.width * 0.55;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 10 : 12,
            vertical: dense ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(.32)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoPill(IconData icon, String text) {
    final maxW = MediaQuery.of(context).size.width - 8.w;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade800),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _priceRange(LocationModel p) {
    String money(num? v) {
      if (v == null) return '--';
      final s = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        buf.write(s[s.length - 1 - i]);
        if (i % 3 == 2 && i != s.length - 1) buf.write(' ');
      }
      return '${buf.toString().split('').reversed.join()} đ';
    }

    final minP = p.minPrice, maxP = p.maxPrice;
    if (minP == null && maxP == null) return '—';
    if ((minP ?? 0) == 0 && (maxP ?? 0) == 0) return 'Miễn phí';
    if (minP != null && maxP != null) {
      if ((minP - maxP).abs() < 0.0001) return money(minP);
      return '${money(minP)} – ${money(maxP)}';
    }
    if (minP != null) return 'Từ ${money(minP)}';
    return 'Đến ${money(maxP)}';
  }

  Widget _fancyTabBar(TabController controller) {
    final r = BorderRadius.circular(12);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        color: Colors.white.withOpacity(.92),
        shape: RoundedRectangleBorder(
          borderRadius: r,
          side: BorderSide(color: Colors.black12.withOpacity(.06)),
        ),
        clipBehavior: Clip.antiAlias,
        child: TabBar(
          controller: controller,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            gradient: Gradients.defaultGradientBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          tabs: const [
            Tab(text: 'Giới thiệu'),
            Tab(text: 'Làng nghề'),
          ],
        ),
      ),
    );
  }
}

class _ModernScaffold extends StatelessWidget {
  final List<Widget> slivers;
  const _ModernScaffold({required this.slivers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ScrollConfiguration(
        behavior: const _NoGlowBehavior(),
        child: CustomScrollView(slivers: slivers),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
