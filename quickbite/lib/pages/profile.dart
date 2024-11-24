import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickbite/firebase/auth.dart';
import 'package:quickbite/firebase/shared.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:quickbite/pages/login.dart';
import 'package:quickbite/pages/register.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false;

  // Lấy ảnh từ thư viện và lưu vào local storage
  Future<void> getImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          isUploading = true;
        });

        // Lấy thư mục ứng dụng
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = 'profile_image.jpg';
        final String filePath = path.join(appDir.path, fileName);

        // Copy ảnh đã chọn vào thư mục ứng dụng
        File imageFile = File(pickedFile.path);
        await imageFile.copy(filePath);

        // Lưu đường dẫn vào SharedPreferences
        await SharedPreferenceHelper().saveUserProfile(filePath);

        setState(() {
          selectedImage = File(filePath);
          profile = filePath;
          isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved successfully!')),
          );
        }
      }
    } catch (e) {
      debugPrint('Image save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: ${e.toString()}')),
        );
      }
      setState(() {
        isUploading = false;
      });
    }
  }

  // Lấy thông tin từ SharedPreferences
  Future<void> getSharedPrefs() async {
    try {
      profile = await SharedPreferenceHelper().getUserProfile();
      name = await SharedPreferenceHelper().getUserName();
      email = await SharedPreferenceHelper().getUserEmail();

      // Kiểm tra xem file ảnh có tồn tại không
      if (profile != null) {
        File profileFile = File(profile!);
        if (await profileFile.exists()) {
          selectedImage = profileFile;
        } else {
          // Nếu file không tồn tại, xóa đường dẫn khỏi SharedPreferences
          await SharedPreferenceHelper().saveUserProfile(null);
          profile = null;
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4.3,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 33, 150, 243),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 105.0),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 6.5),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(60),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: GestureDetector(
                                onTap: getImage,
                                child: isUploading
                                    ? const SizedBox(
                                        height: 120,
                                        width: 120,
                                        child: CircularProgressIndicator(),
                                      )
                                    : selectedImage != null
                                        ? Image.file(
                                            selectedImage!,
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                "images/boy.jpg",
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            "images/boy.jpg",
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  infoCard(Icons.person, "Name", name!),
                  const SizedBox(height: 30.0),
                  infoCard(Icons.email, "Email", email!),
                  const SizedBox(height: 30.0),
                  infoCard(Icons.description, "Terms and Condition", ""),
                  const SizedBox(height: 30.0),
                  actionCard(Icons.delete, "Delete Account", () async {
                    // Hiển thị cảnh báo trước khi xóa
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete your account?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red, // Màu chữ
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // Xóa ảnh profile khi xóa tài khoản
                      if (profile != null) {
                        try {
                          File profileFile = File(profile!);
                          if (await profileFile.exists()) {
                            await profileFile.delete();
                          }
                        } catch (e) {
                          debugPrint('Error deleting profile image: $e');
                        }
                      }

                      // Xóa tài khoản
                      await AuthMethods().deleteuser();

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      }
                    }
                  }),
                  const SizedBox(height: 30.0),
                  actionCard(Icons.logout, "LogOut", () {
                    AuthMethods().SignOut();

                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LogIn()), // Replace the current screen with LogIn
                      );
                    }
                  }),
                ],
              ),
            ),
    );
  }

  // Các widget infoCard và actionCard giữ nguyên như cũ
  Widget infoCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle.isNotEmpty
                      ? Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 20.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
