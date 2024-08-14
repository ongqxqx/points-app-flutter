import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';

class ProductCategory extends GetView<ProductController> {
  const ProductCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("ProductCategory build method called");
    return GetX<ProductController>(
      init: ProductController(),
      builder: (controller) {
        //print("GetX builder called. Categories count: ${controller.categories.length}");
        if (controller.isLoading.value) {
          //return Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return Center(child: Text('noCategoriesAvailable'.tr));
        }

        var sortedCategories = controller.categories;
        sortedCategories.sort((a, b) {
          if (a.id == 'hot') return -1;
          if (b.id == 'hot') return 1;
          return 0;
        });

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: sortedCategories.map((type) {
                bool isSelected = type.id == controller.selectedCategory.value;
                return GestureDetector(
                  onTap: () => controller.setCategory(type.id),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, right: 20.0, bottom: 20.0),
                    child: _buildProductItem(type.id, type['imageURL'], isSelected),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductItem(String name, String imageURL, bool isSelected) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Color(0xFF91BED4),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15, bottom: 10),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        imageURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name.tr,
                    style: TextStyle(fontSize: isSelected ? 30 : 20, color: isSelected ? Colors.white : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}