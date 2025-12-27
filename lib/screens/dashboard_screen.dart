import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:badges/badges.dart' as badges;
import '../controllers/painting_controller.dart';
import '../controllers/cart_controller.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/painting_card.dart';

class DashboardScreen extends StatelessWidget {
  final PaintingController paintingController = Get.find();
  final CartController cartController = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'SSTKTLUI',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Get.snackbar(
                'Notifications',
                'No new notifications',
                snackPosition: SnackPosition.TOP,
              );
            },
          ),
          Obx(() => badges.Badge(
                badgeContent: Text(
                  cartController.itemCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                showBadge: cartController.itemCount > 0,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                ),
              )),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchSection(),
            _buildTrendingSection(),
            _buildCategoryFilter(),
            _buildPaintingsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.padding),
      child: TextField(
        controller: searchController,
        onChanged: (value) => paintingController.searchPaintings(value),
        decoration: InputDecoration(
          hintText: 'Search paintings, artists...',
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          child: Text(
            'Trending Paintings',
            style: AppTextStyles.heading2,
          ),
        ),
        SizedBox(height: 12),
        Obx(() {
          final trendingPaintings = paintingController.trendingPaintings;
          if (trendingPaintings.isEmpty) {
            return SizedBox.shrink();
          }
          return CarouselSlider.builder(
            itemCount: trendingPaintings.length,
            itemBuilder: (context, index, realIndex) {
              final painting = trendingPaintings[index];
              return GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoutes.productDetails,
                  arguments: painting,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(painting.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  painting.title,
                                  style: AppTextStyles.body1.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'by ${painting.artist}',
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              enlargeCenterPage: true,
              viewportFraction: 0.85,
            ),
          );
        }),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
            itemCount: paintingController.categories.length,
            itemBuilder: (context, index) {
              final category = paintingController.categories[index];
              final isSelected = paintingController.selectedCategory == category;
              return Container(
                margin: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => paintingController.filterByCategory(category),
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.text,
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildPaintingsGrid() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Paintings',
            style: AppTextStyles.heading2,
          ),
          SizedBox(height: 16),
          Obx(() {
            final paintings = paintingController.filteredPaintings;
            if (paintings.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No paintings found',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: paintings.length,
              itemBuilder: (context, index) {
                return PaintingCard(painting: paintings[index]);
              },
            );
          }),
        ],
      ),
    );
  }
}