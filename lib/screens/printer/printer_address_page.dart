import 'package:dio/dio.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/screens/style/custom_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jacob_app/utility/app_constant.dart';

import 'package:flutter/material.dart';

import '../../widget/custom_loading.dart';

class PrinterAddressPage extends StatefulWidget {
  const PrinterAddressPage({Key? key}) : super(key: key);

  @override
  _PrinterAddressPageState createState() => _PrinterAddressPageState();
}

class _PrinterAddressPageState extends State<PrinterAddressPage> {
  String username = '';
  String user_id = '';
  String user_group_name = '';
  String printer_address = '';
  String token = '';
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    fetchPrinterAddress(context);
    myFocusNode = FocusNode();
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      user_id = prefs.getString('user_id')!;
      user_group_name = prefs.getString('user_group_name')!;
      printer_address = prefs.getString('printer_address')!;
      token = prefs.getString('token')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget printButton = InkWell(
      onTap: () {
        updatePrinterAddress(context);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 3.0,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.save,
              color: Colors.white,
              size: 20.0,
            ),
            Text(
              'Simpan',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'
              ),
            ),
          ],
        ),
      ),
    );

    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Setting Printer Kasir',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CloseButton()
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(12.0),
                          margin: EdgeInsets.only(left: 12.0, right: 12.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 10.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                                offset: Offset(0, 5),
                                blurRadius: 10.0,
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  color: Colors.grey[200],
                                ),
                                child: TextFormField(
                                  focusNode: myFocusNode,
                                  key: Key(printer_address),
                                  initialValue: printer_address,
                                  onChanged: (text) {
                                    printer_address = text;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Nama Printer Kasir',
                                    labelStyle: TextStyle(
                                        color: myFocusNode.hasFocus
                                            ? Colors.black
                                            : Color(0xffF68D7F)
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 130.0)),
                      ]
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: bottomPadding != 20 ? 20 : bottomPadding),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xffd7d7d7).withOpacity(0.0),
                          Color(0xffd7d7d7).withOpacity(0.5),
                          Color(0xffd7d7d7),
                        ],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter)),
                width: width,
                height: 120,
                child: Center(child: printButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePrinterAddress(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.PRINTER_UPDATE,
        data: {
          'user_id': user_id == null ? null : user_id,
          'printer_address': printer_address == null ? null : printer_address
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        //Messsage
        _onWidgetDidBuild(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nama Printer Kasir Berhasil di Simpan'),
              backgroundColor: Color(0xff36E892),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        Navigator.pop(context);
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
        Navigator.pop(context);
      } else {
        // print(e.message);
      }
    }
  }

  void fetchPrinterAddress(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.PRINTER_ADDRESS,
        data: {'user_id': user_id == null ? null : user_id},
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        String prefPrinterAddress = response.data['data'].toString();
        await prefs.setString('printer_address', prefPrinterAddress);
        printer_address = prefPrinterAddress;
        //Messsage
        //SettingsPage
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
      } else {
        print(e.message);
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
              SizedBox(height: 10.0),
              Container(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
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