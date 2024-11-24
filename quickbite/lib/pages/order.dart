import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickbite/firebase/database.dart';
import 'package:quickbite/firebase/shared.dart';
import 'package:quickbite/widget/support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      amount2 = total;
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    startTimer();
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    total = total + int.parse(ds["Total"]);

                    // Kiểm tra và hiển thị ảnh cục bộ
                    String imagePath = ds["Image"]; // Đường dẫn hình ảnh
                    File imageFile =
                        File(imagePath); // Chuyển đổi thành đối tượng File

                    return Container(
                      margin: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 90,
                                width: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(ds["Quantity"])),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),

                              // Kiểm tra nếu ảnh tồn tại và hiển thị
                              imageFile.existsSync()
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(
                                        imageFile,
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.asset(
                                        "assets/default_image.png", // Hình ảnh mặc định
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds["Name"],
                                    style: AppWidget.semiBoldTextFeildStyle(),
                                  ),
                                  Text(
                                    "\$" + ds["Total"],
                                    style: AppWidget.semiBoldTextFeildStyle(),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      "Food Cart",
                      style: AppWidget.HeadlineTextFeildStyle(),
                    )))),
            SizedBox(
              height: 20.0,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: foodCart()),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  Text(
                    "\$$total",
                    style: AppWidget.semiBoldTextFeildStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                int amount = int.parse(wallet!) - amount2;

                // Cập nhật ví người dùng sau khi checkout
                await DatabaseMethods()
                    .UpdateUserwallet(id!, amount.toString());
                await SharedPreferenceHelper()
                    .saveUserWallet(amount.toString());

                // Xóa tất cả sản phẩm trong giỏ hàng sau khi thanh toán
                await DatabaseMethods().clearFoodCart(id!);

                // Hiển thị thông báo khi checkout thành công
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Successfully!"),
                      content: Text("Thank you for your order!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK")),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
