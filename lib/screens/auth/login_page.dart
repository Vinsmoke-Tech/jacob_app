import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/navbar/bottom_navbar.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/widget/custom_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool obscureText;
  late bool obscureText2;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
    void initState() {
    // TODO: implement initState
    super.initState();
    obscureText = true;
    obscureText2 = true;
    // loadSharedPreference();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
            appBar: AppBar(
            backgroundColor: transparentBrown,
              title: const Text('Login', style: TextStyle(color: white),),
              
            ),
            key: scaffoldKey,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 70).r,
                    decoration: const BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage('assets/image/logo-v1-96x96.png'),
                    )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0).r,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0).r,
                        ),
                        hintText: 'Username',
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0).r,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: !obscureText
                                    ? Color.fromARGB(255, 143, 143, 143).withOpacity(0.3)
                                    : Color.fromARGB(255, 143, 143, 143),
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                      height: 80.h,
                      width: 200.w,
                      padding: const EdgeInsets.all(20).r,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: transparentBrown,
                          minimumSize: Size.fromHeight(50.h),
                        ),
                        child: const Text('Log In', style: TextStyle(color: white), ),
                        onPressed: () {
                          loginValidation(context);
                        },
                      )),
                
                ],
              ),
            ));
  }

   void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void loginValidation(BuildContext context) async {
    bool isLoginValid = true;
    FocusScope.of(context).requestFocus(FocusNode());

    if (emailController.text.isEmpty) {
      isLoginValid = false;
      _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username Tidak Boleh Kosong'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            
          ),
        );
      });
    }

    if (passwordController.text.isEmpty) {
      isLoginValid = false;
      
      _onWidgetDidBuild(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password Tidak Boleh Kosong'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only( bottom: MediaQuery.of(context).size.height - 150,left: 10,right: 10),

          ),
        );
      });
    }
    if (isLoginValid) {
      fetchLogin(context, emailController.text, passwordController.text);
    }
  }

  fetchLogin(BuildContext context, String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    showLoaderDialog(context);
    try {
      Response response;
      var dio = Dio();
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.LOGIN,
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        // ignore: use_build_context_synchronously
        hideLoaderDialog(context);
        //setSharedPreference
        String prefUsername = response.data['conntent']['username'];
        String prefToken = response.data['token'];
        await prefs.setString('username', prefUsername);
        await prefs.setString('token', prefToken);

        //Messsage
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Berhasil'),
              backgroundColor: Color(0xff36E892),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        //homePage
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    } on DioError catch (e) {
      // ignore: use_build_context_synchronously
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
      } else {
        print(e.message);
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server Error'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
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
              const CustomLoading(),
              const SizedBox(height: 10.0),
              Container(
                  child: const Text(
                    'Loading...',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                    ),
                  ),
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

}