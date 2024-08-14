import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:points/product/components/product_detail.dart';
import 'product_controller.dart';

class ProductListByCategory extends StatelessWidget {
  const ProductListByCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find();

    return Obx(() {
      if (controller.isLoading.value) {
        //return Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text('No products available'),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            var product = controller.products[index];
            return GestureDetector(
              onTap: () {
                ProductDetail.showProductDetailDialog(context, product);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white.withOpacity(0.5),
                  //     spreadRadius: -4,
                  //     blurRadius: 3,
                  //     offset: Offset(0, 1),
                  //   ),
                  // ],
                ),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFD9E8F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  product['imageURL'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${product['name']}',
                                style: TextStyle(
                                    color: Color(0xFF003354),
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              //SizedBox(height: 8),
                              Text(
                                '${product['pointToClaim']} ${'pts'.tr}',
                                style: TextStyle(
                                  color: Color(0xFF003354),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${product['quantity']} ${'lefts'.tr}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF91BED4),
                                  ),
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
        ),
      );
    });
  }
}