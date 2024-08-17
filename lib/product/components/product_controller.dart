import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  var selectedCategory = 'hot'.obs; // Observable to track the selected category
  var products = <QueryDocumentSnapshot>[].obs; // Observable list to store fetched products
  var categories = <DocumentSnapshot>[].obs; // Observable list to store fetched categories
  var isLoading = true.obs; // Observable to track loading state for products
  var isCategoryLoading = true.obs; // Observable to track loading state for categories

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // Fetch categories when the controller initializes
    _checkAuthAndFetchData(); // Check authentication status and fetch data
  }

  void _checkAuthAndFetchData() async {
    // Check if the user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      // If no user is logged in, attempt anonymous sign-in
      try {
        await FirebaseAuth.instance.signInAnonymously();
      } catch (e) {
        // Handle sign-in error
        return;
      }
    }
    // Fetch categories and products after authentication
    fetchCategories();
    fetchProducts();
  }

  void setCategory(String category) {
    selectedCategory.value = category; // Update the selected category
    fetchProducts(); // Fetch products based on the selected category
  }

  void fetchCategories() {
    isCategoryLoading.value = true; // Set loading state for categories
    FirebaseFirestore.instance
        .collection('product_category')
        .get()
        .then((snapshot) {
      categories.value = snapshot.docs; // Update categories with fetched data
      isCategoryLoading.value = false; // Set loading state to false
    }).catchError((error) {
      // Handle error while fetching categories
      if (error is FirebaseException) {
        // Handle specific Firebase error if necessary
      }
      isCategoryLoading.value = false; // Set loading state to false in case of error
    });
  }

  void fetchProducts() async {
    isLoading.value = true; // Set loading state for products
    try {
      QuerySnapshot snapshot;
      if (selectedCategory.value == 'hot') {
        // Fetch products with 'hot' status if the selected category is 'hot'
        snapshot = await FirebaseFirestore.instance
            .collection('product_list')
            .where('status', isEqualTo: 'hot')
            .get();
      } else {
        // Fetch products based on the selected category
        snapshot = await FirebaseFirestore.instance
            .collection('product_list')
            .where('category', isEqualTo: selectedCategory.value)
            .get();
      }
      products.value = snapshot.docs; // Update products with fetched data
    } catch (e) {
      // Handle error while fetching products
      products.clear(); // Clear the product list in case of error
    } finally {
      isLoading.value = false; // Set loading state to false after fetching
    }
  }
}
