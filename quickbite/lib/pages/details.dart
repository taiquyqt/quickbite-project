import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quickbite/firebase/database.dart';
import 'package:quickbite/firebase/shared.dart';
import 'package:quickbite/widget/support.dart';

class Details extends StatefulWidget {
  final String image, name, detail, price;

  const Details({
    super.key,
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int a = 1, total = 0;
  String? id;

  // Hàm kiểm tra và hiển thị ảnh an toàn
  Widget buildImageWidget() {
    File imageFile = File(widget.image);

    if (imageFile.existsSync()) {
      return Image.file(
        imageFile,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.5,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 50,
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.5,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 50,
          ),
        ),
      );
    }
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    total = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 62.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                )),

            // Sử dụng buildImageWidget thay cho Image.network
            buildImageWidget(),

            const SizedBox(height: 15.0),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      --a;
                      total = total - int.parse(widget.price);
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 150, 243),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                Text(
                  a.toString(),
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    ++a;
                    total = total + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 150, 243),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.detail,
              maxLines: 4,
              style: AppWidget.LightTextFeildStyle(),
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Text(
                  "Delivery Time",
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                const SizedBox(width: 25.0),
                const Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                const SizedBox(width: 5.0),
                Text(
                  "30 min",
                  style: AppWidget.semiBoldTextFeildStyle(),
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                      Text(
                        "\$" + total.toString(),
                        style: AppWidget.HeadlineTextFeildStyle(),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> addFoodToCart = {
                        "Name": widget.name,
                        "Quantity": a.toString(),
                        "Total": total.toString(),
                        "Image": widget.image
                      };
                      await DatabaseMethods().addFoodToCart(addFoodToCart, id!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color.fromARGB(255, 7, 229, 96),
                        content: Text(
                          "Food Added to Cart",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 33, 150, 243),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Poppins'),
                          ),
                          const SizedBox(width: 30.0),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 33, 150, 243),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
