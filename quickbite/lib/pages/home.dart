import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickbite/firebase/database.dart';
import 'package:quickbite/pages/details.dart';
import 'package:quickbite/widget/support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool milktea = false, sandwich = false, noodles = false, poke_bowl = false;
  Stream? fooditemStream;

  // Hàm tải dữ liệu món ăn từ Firestore
  ontheload(String category) async {
    fooditemStream = DatabaseMethods().getFoodItem(category);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Mặc định tải món "Noodles"
    ontheload("Noodles");
  }

  // Widget hiển thị ảnh an toàn
  Widget buildImageWidget(String imagePath, double height, double width) {
    File imageFile = File(imagePath);

    if (imageFile.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          imageFile,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              width: width,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            );
          },
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: height,
          width: width,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        ),
      );
    }
  }

  // Hiển thị danh sách món ăn theo chiều dọc
  Widget allItemVertically() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      detail: ds["Detail"],
                      name: ds["Name"],
                      price: ds["Price"],
                      image: ds["Image"],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sử dụng buildImageWidget để hiển thị ảnh
                        buildImageWidget(ds["Image"], 120, 120),
                        const SizedBox(width: 20.0),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                ds["Name"],
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "The richness of the meaty tomato sauce",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "\$" + ds["Price"],
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Hiển thị danh sách món ăn theo chiều ngang
  Widget allItem() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      detail: ds["Detail"],
                      name: ds["Name"],
                      price: ds["Price"],
                      image: ds["Image"],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sử dụng buildImageWidget để hiển thị ảnh
                        buildImageWidget(ds["Image"], 150, 150),
                        Text(ds["Name"],
                            style: AppWidget.semiBoldTextFeildStyle()),
                        const SizedBox(height: 5.0),
                        Text("Fresh and Healthy",
                            style: AppWidget.LightTextFeildStyle()),
                        const SizedBox(height: 5.0),
                        Text("\$" + ds["Price"],
                            style: AppWidget.semiBoldTextFeildStyle())
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Hiển thị các lựa chọn món ăn
  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCategoryButton("Milk-Tea", milktea, "images/milk-tea.png"),
        buildCategoryButton("Sandwich", sandwich, "images/sandwich.png"),
        buildCategoryButton("Noodles", noodles, "images/noodles.png"),
        buildCategoryButton("Poke-Bowl", poke_bowl, "images/bowl.png"),
      ],
    );
  }

  // Hàm tạo nút lựa chọn món ăn
  Widget buildCategoryButton(
      String category, bool isSelected, String imagePath) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          milktea = category == "Milk-Tea";
          sandwich = category == "Sandwich";
          noodles = category == "Noodles";
          poke_bowl = category == "Poke-Bowl";
        });
        await ontheload(category); // Tải dữ liệu theo loại món ăn
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected ? Color.fromARGB(255, 33, 150, 243) : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            imagePath,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 60.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello,", style: AppWidget.boldTextFeildStyle()),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 33, 150, 243),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text("Eat Well Every Day",
                  style: AppWidget.HeadlineTextFeildStyle()),
              Text("Discover and Enjoy Great Food",
                  style: AppWidget.LightTextFeildStyle()),
              const SizedBox(height: 20.0),
              Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: showItem()),
              const SizedBox(height: 30.0),
              Container(
                height: 270,
                child: allItem(),
              ),
              const SizedBox(height: 30.0),
              allItemVertically(),
            ],
          ),
        ),
      ),
    );
  }
}
