import 'package:flutter/material.dart';
import 'package:quickbite/widget/support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteFood extends StatefulWidget {
  const DeleteFood({super.key});

  @override
  State<DeleteFood> createState() => _DeleteFoodState();
}

class _DeleteFoodState extends State<DeleteFood> {
  List<Map<String, dynamic>> foodItems = []; // List of food items
  bool isLoading = true;

  // Danh sách các category
  List<String> categories = ['Milk-Tea', 'Sandwich', 'Noodles', 'Poke-Bowl'];

  // Fetch food items từ tất cả các category
  Future<void> getFoodItems() async {
    try {
      List<Map<String, dynamic>> allFoodItems = [];

      // Lặp qua từng category và lấy dữ liệu
      for (String category in categories) {
        var fetchedItems =
            await FirebaseFirestore.instance.collection(category).get();

        fetchedItems.docs.forEach((doc) {
          allFoodItems.add(doc.data());
        });
      }

      setState(() {
        foodItems = allFoodItems;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching food items: $e");
    }
  }

  // Xóa food item theo tên trong tất cả các category
  Future<void> deleteFoodItemByName(String name) async {
    try {
      bool itemDeleted = false;

      // Lặp qua từng category và xóa food item
      for (String category in categories) {
        var foodDocs = await FirebaseFirestore.instance
            .collection(category)
            .where("Name", isEqualTo: name)
            .get();

        if (foodDocs.docs.isNotEmpty) {
          for (var doc in foodDocs.docs) {
            await doc.reference.delete();
            itemDeleted = true;
          }
        }
      }

      if (itemDeleted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Food Item deleted successfully",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
        getFoodItems(); // Refresh the list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No food item found with this name",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Error deleting item: $e",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getFoodItems(); // Fetch food items when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Delete Food",
          style: AppWidget.HeadlineTextFeildStyle(),
        ),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading while fetching data
          : foodItems.isEmpty
              ? Center(child: Text("No food items available"))
              : ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    var foodItem = foodItems[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      child: ListTile(
                        title: Text(foodItem["Name"]),
                        subtitle: Text("Price: \$${foodItem["Price"]}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteFoodItemByName(foodItem["Name"]);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
