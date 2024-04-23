import 'package:flutter/material.dart';
import 'package:test_pro/screens/file_manager_screen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/on_board_image.png",
                fit: BoxFit.cover, width: double.infinity, height: 300),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Perpustakaan Digital\n\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )),
                  TextSpan(
                    text:
                        "E-Perpus adalah aplikasi perpustakaan digital yang menyewakan buku berbasis mobile.",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>FileManagerScreen()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff29BB89),

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                  )),
              child: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}
