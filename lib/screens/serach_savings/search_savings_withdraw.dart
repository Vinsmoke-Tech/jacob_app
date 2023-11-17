import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/member_deposit/member_list.dart';
import 'package:jacob_app/screens/member_withdraw/member_list_withdraw.dart';
import 'package:jacob_app/screens/serach_savings/list_savings.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchSavingsWithdraw extends StatefulWidget {
  const SearchSavingsWithdraw({Key? key}) : super(key: key);

  @override
  State<SearchSavingsWithdraw> createState() => _SearchSavingsWithdrawState();
}

class _SearchSavingsWithdrawState extends State<SearchSavingsWithdraw> {
  String token = '';
  TextEditingController memberNoController = TextEditingController();
  String searchData = '';

  Future<void> searchDataFromApi() async {

  final prefs = await SharedPreferences.getInstance();
    Response response;
    token = prefs.getString('token')!;
    try {
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";

      Response response = await Dio().post(
        AppConstans.BASE_URL+AppConstans.DATASAVINGS,
        queryParameters: {'data': memberNoController.text},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          searchData = json.encode(response.data);
        });
      } else {
        // Tambahkan logika penanganan kesalahan sesuai kebutuhan Anda
        print('Gagal mendapatkan data dari API');
      }
    } catch (error) {
      // Tambahkan logika penanganan kesalahan sesuai kebutuhan Anda
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparentBrown,
        title: const Text('Cari No Simpanan', style: TextStyle(color: white)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MemberListWithdraw()),
                    );
                  },
                  icon: const Icon(Icons.person_search, color: Colors.white),
                ),
                SizedBox(width: 5.w),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner_outlined, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 18).r,
            child: TextFormField(
              controller: memberNoController,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'No Simpanan',
                labelStyle: TextStyle(fontSize: 15.sp, color: black),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: InkWell(
              onTap: () async {
                await searchDataFromApi();
                if (searchData.isNotEmpty) {
                  // Tambahkan navigasi ke halaman berikutnya dengan membawa data yang ditemukan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NextPage(data: searchData)),
                  );
                }
              },
              child: Container(
                width: 100.w,
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: transparentBrown,
                  borderRadius: BorderRadius.circular(25).r,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Cari',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
