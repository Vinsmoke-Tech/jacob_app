import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/printer/component/mandatory_print_page.dart';
import 'package:jacob_app/screens/serach_savings/search_mandatory_savings.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/utility/currency_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MandatorySavingsPage extends StatefulWidget {

  @override
  State<MandatorySavingsPage> createState() => _MandatorySavingsPageState();
}

class _MandatorySavingsPageState extends State<MandatorySavingsPage> {
  String username = '';
  String token = '';
  String user_id = '';
  String saving_id = '';
  String mutationamount = '';
  var savingsidJson = [];
  var member_id ;


TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreference();
    member_id = 0;
    fetchSaldo(context, member_id);
    
  }

  

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    
      setState(() {
      user_id = prefs.getString('user_id')?? '';
      token = prefs.getString('token')?? '';

    });
  }

    Future<void> refresh()async{
    fetchSaldo(context, member_id);
  }

    Future <void> fetchSaldo(BuildContext context, int member_id) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.LISTMANDATORYSAVINGS,
        data: {
          'user_id': user_id == null ? null : user_id,
          'member_id':member_id == null ? null : member_id,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil

          setState(() {
            saving_id =json.encode(response.data['data']);
            savingsidJson = response.data['data'];
          });
          print(savingsidJson);

            
      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        String errorMessage = e.response?.data['message'];

        } else {
        print(e.message);
      }
    }
  }

  void printMandatorySaving(BuildContext context, var member_id) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('member_id', member_id.toString());
    //print status variabel local
    prefs.setString('print_status', "0");

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MandatoryPrintPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simpanan Wajib',style: TextStyle(color: white),),
        backgroundColor: const Color(0xffa5683a),
      ),
      floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(_animatedRoute());
                  },
                  backgroundColor: const Color(0xffa5683a),
                  elevation: 10,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                body: RefreshIndicator(
          onRefresh: refresh,
          backgroundColor: blue,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10).r,
              child: Container(
                child: savingsidJson.isEmpty
                  ?   Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/image/support.png'),
                            Text(
                              'Data not found',
                              style: TextStyle(fontSize: 16.sp, color: Colors.black),
                            ),
                          ],
                        )
                      ) // Show a loading indicator while data is being fetched.
                  : ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: savingsidJson.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Generated code for this ListTile Widget...
                          GestureDetector(
                            onTap: () {
                              // Aksi yang ingin Anda lakukan saat ListTile ditekan
                              printMandatorySaving(context,
                              savingsidJson[index]['member_id']);
                            },
                            child: ListTile(
                              title: Text(
                                (savingsidJson[index]['member_name'].toString()),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: transparentBrown,
                                ),
                                overflow: TextOverflow.ellipsis, // Memberikan elipsis jika teks overflow
                                maxLines: 1, // Hanya satu baris teks yang ditampilkan
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              
                                  Text(
                                    (savingsidJson[index]['updated_at'] != null
                                      ? _formatDateTime(savingsidJson[index]['updated_at'])
                                      : 'Data Kosong'),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: black,
                                    ),
                                  ),
                                  
                                ],
                              ),
                              trailing: Text(
                                          CurrencyFormat.convertToIdr(
                                            double.parse(savingsidJson[index]['member_mandatory_savings_last_balance'] ?? '0'),
                                            2, // specify the number of decimal digits
                                            initialValue: 'Data Kosong',
                                          ),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: black,
                                          ),
                                        ),
                              tileColor: darkGrey,
                              dense: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
              ),
            ),
        ),
      ),
    );
  }

    Route _animatedRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SearchMandatorySavings(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {

        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }

    // Function to convert and format the DateTime
String _formatDateTime(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    // You can format the DateTime as needed using DateFormat or any other method
    String formattedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
    return formattedDateTime;
  } catch (e) {
    print("Error parsing DateTime: $e");
    return 'Invalid Date';
  }
}
}
