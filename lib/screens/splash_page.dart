// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jacob_app/screens/auth/login_page.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/navbar/bottom_navbar.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> 
 with SingleTickerProviderStateMixin {
  String? token;
  late Animation<double> opacity;
  late AnimationController controller;

  startSplashScreen() async {
    var duration = const Duration(milliseconds: 2500);
    return Timer(duration, () {
      if (token != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));

      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

    @override
    void initState() {
      super.initState();
      loadSharedPreference();
      getLoginState(context);
      startSplashScreen();
      controller = AnimationController(
          duration: const Duration(milliseconds: 2500), vsync: this);
      opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
        ..addListener(() {
          setState(() {});
        });
      controller.forward().then((_) {
        getLoginState(context);
      });
    }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    // ignore: non_constant_identifier_names
  
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigationPage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
   Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.jpg'), fit: BoxFit.cover)),
      child: Container(
        decoration: const BoxDecoration(color: transparentBrown),
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                          'assets/image/logo-v1-250x250.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: 'Powered by '),
                          TextSpan(
                              text: 'Cipta Solutindo Tech',
                              style: TextStyle(fontWeight: FontWeight.bold)
                          )
                        ]
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

    void getLoginState(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.LOGIN_STATE,
        data: {},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        //SettingsPage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BottomNavBar()));
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selamat Datang Kembali'),
              backgroundColor: Color(0xff36E892),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        // ignore: unused_local_variable
        String errorMessage = e.response?.data['message'];
      } else {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session Telah Habis'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      }
    }
  }
  
    void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

}