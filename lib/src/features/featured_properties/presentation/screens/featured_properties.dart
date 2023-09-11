import 'package:chip_list/chip_list.dart';
import 'package:dream_home/src/constants/screen.dart';
import 'package:dream_home/src/features/featured_properties/application/blocs/bloc/featured_properties_bloc.dart';
import 'package:dream_home/src/features/featured_properties/domain/models/property.dart';
import 'package:dream_home/src/features/featured_properties/presentation/views/app_bar.dart';
import 'package:dream_home/src/features/featured_properties/presentation/views/filters_bottom_sheet.dart';
import 'package:dream_home/src/features/featured_properties/presentation/views/property_list.dart';
import 'package:dream_home/src/features/featured_properties/presentation/widgets/featured_image.dart';
import 'package:dream_home/src/features/featured_properties/presentation/widgets/featured_info.dart';
import 'package:dream_home/src/theme/pellet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class FeaturedPropertiesScreen extends StatefulWidget {
  const FeaturedPropertiesScreen({super.key, required this.properties});
  final List<Property> properties;

  @override
  State<FeaturedPropertiesScreen> createState() =>
      _FeaturedPropertiesScreenState();
}

class _FeaturedPropertiesScreenState extends State<FeaturedPropertiesScreen> {
  final String baseUrl = 'https://dream-home.pockethost.io/api/files/';
  final List<String> filterChip = ['Buy', 'Rent', 'Commercial', 'Furnished'];
  final selectedFilter = [0];
  late final TextEditingController _searchController;
  late List<Property> filteredProperties;
  @override
  void initState() {
    super.initState();
    filteredProperties = widget.properties;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = ScreenSize.height(context);

    return BlocListener<FeaturedPropertiesBloc, FeaturedPropertiesState>(
      listener: (context, state) {
        if (state is FeaturedFilteredProperties) {
          filteredProperties = state.properties;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 2),
          const AppBarView(),
          SizedBox(height: height * 1),
          Row(
            children: [
              CommonFeaturesSearchField(
                showFilters: true,
                searchController: _searchController,
              ),
            ],
          ),
          SizedBox(height: height * 1),
          ChipList(
            listOfChipNames: filterChip,
            listOfChipIndicesCurrentlySeclected: selectedFilter,
            activeBgColorList: [Pellet.kPrimaryColor],
            inactiveTextColorList: [Pellet.kDark],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            extraOnToggle: (index) {
              // Using setState as it is required by the library to rebuild the ui
              setState(() {
                context.read<FeaturedPropertiesBloc>().add(
                      FeaturedFilterChipSelected(
                        properties: widget.properties,
                        index: index,
                      ),
                    );
              });
            },
          ),
          SizedBox(height: height * 2),
          if (filteredProperties.isNotEmpty) ...[
            FeaturedImage(
              '$baseUrl/${filteredProperties.first.collectionId}/${filteredProperties.first.id}/${filteredProperties.first.images!.first}',
              borderColor: Pellet.kPrimaryColor,
            ),
            SizedBox(height: height * 2),
            FeaturedInfo(
              leading: 'Featured Properties',
              trailing: 'View All',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/view-all',
                  arguments: {
                    'properties': filteredProperties,
                  },
                );
              },
            ),
            SizedBox(height: height * 1),
            PropertyListView(properties: filteredProperties, baseUrl: baseUrl),
          ] else ...[
            const Spacer(),
            Icon(IconlyLight.filter, size: 50, color: Pellet.kDark),
            const SizedBox(height: 16),
            const Text(
              'No properties found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ],
      ),
    );
  }
}

class CommonFeaturesSearchField extends StatelessWidget {
  const CommonFeaturesSearchField({
    super.key,
    this.showFilters = false,
    required TextEditingController searchController,
    this.borderColor = Colors.transparent,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final bool showFilters;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: _searchController,
          keyboardType: TextInputType.text,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            hintText: 'Search for anything',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: borderColor,
                width: 2.0,
              ),
            ),
            prefixIcon: Icon(
              IconlyLight.search,
              color: Pellet.kDark,
            ),
            suffixIcon: showFilters
                ? IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const FiltersBottomSheet(),
                        isScrollControlled: true,
                        showDragHandle: true,
                        backgroundColor: Pellet.kWhite,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      IconlyLight.filter,
                      color: Pellet.kDark,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}