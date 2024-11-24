import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Add user details to Firestore
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  // Update user wallet balance
  Future UpdateUserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }

  // Add food item to a collection (e.g., food items collection)
  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  // Get all food items from a specific collection
  Stream<QuerySnapshot> getFoodItem(String name) {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  // Add food item to the user's cart
  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  // Get food cart items for a specific user
  Stream<QuerySnapshot> getFoodCart(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  // Method to clear food cart items after checkout
  Future<void> clearFoodCart(String id) async {
    try {
      // Get all food items from the cart
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('Cart')
          .get();

      // Delete each item in the cart
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print("Food cart cleared successfully");
    } catch (e) {
      print("Error clearing food cart: $e");
    }
  }
}

// Get all food items from a specific collection (e.g., "foodItems")
Future<List<Map<String, dynamic>>> getFoodItems(String collectionName) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .get(); // Fetch all documents in the collection
    List<Map<String, dynamic>> foodItems = [];

    // Parse each document into a Map
    querySnapshot.docs.forEach((doc) {
      foodItems.add(doc.data() as Map<String, dynamic>);
    });
    return foodItems;
  } catch (e) {
    print("Error fetching food items: $e");
    return []; // Return an empty list if there's an error
  }
}

// Xóa món ăn theo tên
Future<void> deleteFoodItemByName(
    String collectionName, String foodName) async {
  try {
    // Query to find the food item by its name
    var foodDocs = await FirebaseFirestore.instance
        .collection(collectionName)
        .where("Name", isEqualTo: foodName)
        .get();

    // Delete each matching document
    if (foodDocs.docs.isNotEmpty) {
      for (var doc in foodDocs.docs) {
        await doc.reference.delete();
      }
      print("Food item deleted successfully");
    } else {
      print("No food item found with the name: $foodName");
    }
  } catch (e) {
    print("Error deleting food item: $e");
  }
}
