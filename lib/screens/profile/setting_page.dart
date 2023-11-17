// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/auth/login_page.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/profile/about_page.dart';
import 'package:jacob_app/screens/profile/change_password_page.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/widget/custom_loading.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  String username = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      token = prefs.getString('token')!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffa5683a),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
          Padding(
          padding: const EdgeInsets.only(top: 20), 
          // Mengatur jarak dari atas sebanyak 10px
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3, // 30% dari lebar layar
                height: MediaQuery.of(context).size.width * 0.3, // 30% dari tinggi layar
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 3,
                  ),
                ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(2.w, 2.h, 2.w, 2.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.15), // 15% dari lebar layar
                  child: Image.asset(
                          'assets/image/logo-v1-96x96.png',
                          width: 50.w, // Set the desired width
                          height: 50.h, 
                          fit: BoxFit.fill, // Set the desired height
                        ),
                ),
              ),
            ),
          ),
              Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0), // Ganti top ke 10px
              child: Text(
                username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const Divider(
                height: 20,
                thickness: 1,
                indent: 24,
                endIndent: 24,
                color: Colors.grey,
              ),
            
            GestureDetector(
                onTap: () {
                  // Tambahkan tindakan yang akan dijalankan ketika widget ini ditekan
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const AboutPage()));
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.w, 10.h, 16.w, 0.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12).w,
                      border: Border.all(
                        color: const Color.fromARGB(255, 80, 80, 80),
                        width: 2.w,
                      ),
                    ),
                    child:  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Icon(
                              Icons.lock_outline,
                              color: Color.fromARGB(255, 23, 23, 23),
                              size: 24.r,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Ganti Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  // Tambahkan tindakan yang akan dijalankan ketika widget ini ditekan
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.w, 10.h, 16.w, 0.h),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12).w,
                      border: Border.all(
                        color: const Color.fromARGB(255, 80, 80, 80),
                        width: 2.w,
                      ),
                    ),
                    child:  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                            child: Icon(
                              Icons.info_outline,
                              color: Color.fromARGB(255, 23, 23, 23),
                              size: 24.r,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                            child: Text(
                              'Buy Assets',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


            // Generated code for this Button Widget...
            const SizedBox(height: 10.0,),
              InkWell(
                  onTap: () {
                  fetchLogout(context);
                  },
                  child: Container(
                  
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom == 0
                            ? 20
                            : MediaQuery.of(context).padding.bottom),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                            offset: Offset(0, 5),
                            blurRadius: 10.0,
                          )
                        ],
                      color:const Color(0xffd7b38e),
                        borderRadius: BorderRadius.circular(38),
                  ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                          size: 22.0,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Montserrat'
                          ),
                        ),
                      ],
                    ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void fetchLogout(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.LOGOUT,
        data: {},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //setSharedPreference
        final removeEmail = await prefs.remove('username');
        final removeToken = await prefs.remove('token');
        //Messsage
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Berhasil'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        //SettingsPage
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }
    } on DioError catch (e) {
      hideLoaderDialog(context);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) =>  LoginPage()));
      } else {
        // print(e.message);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) =>  LoginPage()));
      }
    }
  }

   showLoaderDialog(BuildContext context) {
    Material loading = Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomLoading(),
              SizedBox(height: 10.h),
              Container(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return loading;
      },
    );
  }

  hideLoaderDialog(BuildContext context) {
    return Navigator.pop(context);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

}
