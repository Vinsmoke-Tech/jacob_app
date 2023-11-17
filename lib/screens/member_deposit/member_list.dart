import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/member_deposit/savings_by_member.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberList extends StatefulWidget {

  @override
   State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  String? membername;
  String? memberid;

  var membernameJson = [];
  var memberidJson = [];
  String token = '';
  String user_id = '';
  String member_name = '';
  var savingsAccountId;
  String member_id ='';


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
        setState(() {
          member_name =json.encode(response.data['data']);
          memberidJson = response.data['data'];
        });
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
                              // Aksi yang ingin Anda lakukan saat ListTile ditekan
                              _onListTileTapped(memberidJson[index]);
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

void _onListTileTapped(Map<String, dynamic> byMember) {
  
  String member_id = byMember['member_id'].toString();

    setState(() {
      this.member_id = member_id;
    });
    print(member_id);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SavingByMember(byMember: byMember, data: 'member_id'),
    ),
  );
}


}
