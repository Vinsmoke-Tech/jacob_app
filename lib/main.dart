import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jacob_app/screens/splash_page.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
      return ScreenUtilInit(
        designSize: Size(360, 690),//set DPI 
        minTextAdapt: true,
        splitScreenMode: true,

        builder: (_, child){
          return MediaQuery(
            data :  MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
            child: MaterialApp(
            title: 'Koperasi Jacob',
            debugShowCheckedModeBanner: false,

              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(245, 160, 104, 0)),
                useMaterial3: true,
                primaryColor: const Color(0xffa5683a),
                textTheme: GoogleFonts.poppinsTextTheme(),//set fonts
              ),
                home: SplashPage(),
            ),
          );
        },
      );
  }
}