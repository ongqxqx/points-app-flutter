import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  var selectedCategory = 'hot'.obs;
  var products = <QueryDocumentSnapshot>[].obs;
  var categories = <DocumentSnapshot>[].obs;
  var isLoading = true.obs;
  var isCategoryLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    //print("ProductController onInit called");
    fetchCategories();
    _checkAuthAndFetchData();
  }

  void _checkAuthAndFetchData() async {
    //print("Checking auth status...");
    if (FirebaseAuth.instance.currentUser == null) {
      //print("No user logged in. Attempting anonymous sign in...");
      try {
        await FirebaseAuth.instance.signInAnonymously();
        //print("Anonymous sign in successful");
      } catch (e) {
        //print("Error signing in anonymously: $e");
        return;
      }
    } else {
      //print("User already signed in");
    }
    fetchCategories();
    fetchProducts();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    fetchProducts();
  }

  void fetchCategories() {
    //print("Fetching categories...");
    isCategoryLoading.value = true;
    FirebaseFirestore.instance
        .collection('product_category')
        .get()
        .then((snapshot) {
      //print("Categories fetched. Count: ${snapshot.docs.length}");
      categories.value = snapshot.docs;
      isCategoryLoading.value = false;
    }).catchError((error) {
      //print("Error fetching categories: $error");
      if (error is FirebaseException) {
        //print("Firebase error code: ${error.code}");
        //print("Firebase error message: ${error.message}");
      }
      isCategoryLoading.value = false;
    });
  }

  void fetchProducts() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (selectedCategory.value == 'hot') {
        snapshot = await FirebaseFirestore.instance
            .collection('product_list')
            .where('status', isEqualTo: 'hot')
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('product_list')
            .where('category', isEqualTo: selectedCategory.value)
            .get();
      }
      products.value = snapshot.docs;
    } catch (e) {
      //print("Error fetching products: $e");
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }
}