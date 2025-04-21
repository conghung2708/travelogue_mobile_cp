import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travelogue_mobile/core/blocs/app_bloc.dart';
import 'package:travelogue_mobile/core/blocs/search/search_bloc.dart';
import 'package:travelogue_mobile/core/constants/dimension_constants.dart';
import 'package:travelogue_mobile/core/helpers/asset_helper.dart';
import 'package:travelogue_mobile/core/helpers/image_helper.dart';
import 'package:travelogue_mobile/model/location_model.dart';

import 'package:travelogue_mobile/representation/home/widgets/search_location_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const routeName = '/search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";

  Timer? _debounce;

  void updateSearchResults(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      AppBloc.searchBloc.add(
        SearchLocationEvent(
          searchText: query.trim(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    AppBloc.searchBloc.add(
      CleanSearchEvent(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: updateSearchResults,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Nhập tên địa điểm...',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.black,
                          size: kDefaultIconSize,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(kItemPadding),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: kItemPadding,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                final List<LocationModel> listLocationSearch =
                    state.props[0] as List<LocationModel>;

                return state is SearchInitial
                    ? const SizedBox()
                    : listLocationSearch.isEmpty
                        ? _pageEmpty
                        : ListView.separated(
                            itemCount: listLocationSearch.length,
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade300),
                            itemBuilder: (context, index) {
                              return SearchLocationCard(
                                  locationModel: listLocationSearch[index]);
                            },
                          );
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget get _pageEmpty {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageHelper.loadFromAsset(
            AssetHelper.img_search_not_found,
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            "Không tìm thấy địa điểm nào",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
