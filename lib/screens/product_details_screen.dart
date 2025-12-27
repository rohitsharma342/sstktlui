import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../models/painting.dart';
import '../controllers/cart_controller.dart';
import '../utils/constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  final CartController cartController = Get.find();
  final RxInt selectedQuantity = 1.obs;

  @override
  Widget build(BuildContext context) {
    final Painting painting = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Painting Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageViewer(painting),
            _buildDetailsSection(painting),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(painting),
    );
  }

  Widget _buildImageViewer(Painting painting) {
    return Container(
      height: 400,
      child: GestureDetector(
        onTap: () => _showFullScreenImage(painting.imageUrl),
        child: Hero(
          tag: 'painting-${painting.id}',
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(painting.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(Painting painting) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            painting.title,
            style: AppTextStyles.heading1,
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showArtistBio(painting),
            child: Row(
              children: [
                Text(
                  'by ${painting.artist}',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              painting.category,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Description',
            style: AppTextStyles.heading2,
          ),
          SizedBox(height: 8),
          Text(
            painting.description,
            style: AppTextStyles.body1,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Price: ',
                style: AppTextStyles.body1,
              ),
              Text(
                '\$${painting.price.toStringAsFixed(2)}',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Quantity',
            style: AppTextStyles.heading2,
          ),
          SizedBox(height: 8),
          _buildQuantitySelector(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: AppColors.primary),
                onPressed: () {
                  if (selectedQuantity.value > 1) {
                    selectedQuantity.value--;
                  }
                },
              ),
              Obx(() => Container(
                    width: 40,
                    child: Text(
                      selectedQuantity.value.toString(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              IconButton(
                icon: Icon(Icons.add, color: AppColors.primary),
                onPressed: () {
                  selectedQuantity.value++;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(Painting painting) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: AppTextStyles.body2,
                ),
                Obx(() => Text(
                      '\$${(painting.price * selectedQuantity.value).toStringAsFixed(2)}',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.primary,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                cartController.addToCart(painting, selectedQuantity.value);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
              ),
              child: Text(
                'Add to Cart',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        child: Container(
          child: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: BoxDecoration(color: Colors.black),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArtistBio(Painting painting) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(AppDimensions.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About the Artist',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: 16),
            Text(
              painting.artist,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              painting.artistBio.isNotEmpty
                  ? painting.artistBio
                  : 'No biography available for this artist.',
              style: AppTextStyles.body1,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}