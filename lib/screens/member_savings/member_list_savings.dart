import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/member_withdraw/withdraw_by_member.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberListWithdraw extends StatefulWidget {
  @override
   State<MemberListWithdraw> createState() => _MemberListWithdrawState();
}

class _MemberListWithdrawState extends State<MemberListWithdraw> {
  String member_id ='';
  String member_name = '';
  String? memberid;
  var memberidJson = [];
  String? membername;
  var membernameJson = [];
  var savingsAccountId;
  String token = '';
  String user_id = '';

  @override
  void initState() {
    super.initState();
    savingsAccountId = 0;
    fetchData(context, savingsAccountId);
  }

  Future<void> refresh()async{
    fetchData(context, savingsAccountId);
  }

  Future <void> fetchData(BuildContext context, int savingsAccountId) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.DATASAVINGS,
        data: {
          'token' : token,
          'member_id': member_id,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
          String member_name =json.encode(response.data['data']);
          memberidJson = response.data['data'];
          await prefs.setString('member_name', member_name);
        // print(memberidJson);
      }
    } on DioError catch (e) {
      print(e);
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
        // print(e.message);
      }
    }
  }

    showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Members',style: TextStyle(color: white),),
        backgroundColor: transparentBrown,
      ),
      body: RefreshIndicator(
          onRefresh: refresh,
          backgroundColor: blue,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(10).r,
              child: Container(
                child: memberidJson.isEmpty
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
                    itemCount: memberidJson.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Generated code for this ListTile Widget...
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                item_category_id = itemCategoryJson[index]['item_category_id'];
                              });
                              fetchItem(context, item_category_id);
                            },
                            child: ListTile(
                              title: Text(
                                (memberidJson[index]['member_no'].toString()),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: transparentBrown,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (memberidJson[index]['member_name'] ?? 'Data Kosong'),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: black,
                                    ),
                                  ),
                                  Text(
                                    (memberidJson[index]['member_address_now'] ?? 'Data Kosong'),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: black,
                                    ),
                                  ),
                                  
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: transparentBrown,
                                size: 14.sp,
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
}
