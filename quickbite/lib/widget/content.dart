import 'package:flutter/material.dart';

// Class UnboardingContent để chứa dữ liệu
class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

// Danh sách các nội dung cho Onboarding
List<UnboardingContent> contents = [
  UnboardingContent(
    description: 'Pick your food from our menu\nMore than 35 times',
    image: "images/screen1.png",
    title: 'Select from Our Best Menu',
  ),
  UnboardingContent(
    description: 'You can pay cash on delivery\nand card payment is available',
    image: "images/screen2.png",
    title: 'Easy and Online Payment',
  ),
  UnboardingContent(
    description: 'Deliver your food at your\nDoorstep',
    image: "images/screen3.png",
    title: 'Quick Delivery at Your Doorstep',
  ),
];

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: contents.length, // Lấy số lượng items trong contents
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    contents[index].image,
                    fit: BoxFit.contain, // Điều chỉnh ảnh
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        contents[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
