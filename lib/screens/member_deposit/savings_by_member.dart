
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/member_deposit/member_deposit.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/utility/currency_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SavingByMember extends StatefulWidget {

  late Map<String, dynamic> byMember;
  final String data;
  
  SavingByMember({required this.byMember, required  this.data});

  @override
  State<SavingByMember> createState() => _SavingByMemberState();
}

class _SavingByMemberState extends State<SavingByMember> {

    String token = '';
    String user_id = '';
    late String member_id;
    String savings_account_id ='';
    String member_name = '';
    var membernameJson  = [];
    
    @override
  void initState() {
    super.initState();
    member_id = widget.byMember[widget.data].toString();
    fetchData(context, member_id); // Call fetchData here
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
    });

  }

  void fetchData(BuildContext context,String member_id) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.POSTSAVINGS+member_id,
        data: {
          'user_id' : user_id,
          'token' : token,
          'member_id': member_id,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        setState(() {
          membernameJson  = response.data['data'];

          // print(membernameJson);
        });

      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        // ignore: unused_local_variable
        String errorMessage = e.response?.data['message'];
        
      } else {
        // print(e.message);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('List of Members',style: TextStyle(color: white),),
        backgroundColor: transparentBrown,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10).r,
            child: Container(
              child: membernameJson.isEmpty
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
                  itemCount: membernameJson.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // Generated code for this ListTile Widget...
                        GestureDetector(
                          onTap: () {
                            // Aksi yang ingin Anda lakukan saat ListTile ditekan
                            _onListTileTapped(membernameJson[index]);
                          },
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (membernameJson[index]['savingdata']['savings_name'].toString()),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: transparentBrown,
                                  ),
                                ),
                                Text(
                                  (membernameJson[index]['savings_account_no'] ?? 'Data Kosong'),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: transparentBrown,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CurrencyFormat.convertToIdr(
                                    double.parse(membernameJson[index]['savings_account_last_balance'] ?? '0'),
                                    2, // specify the number of decimal digits
                                    initialValue: 'Data Kosong',
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.sp,
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

    );
  }

  void _onListTileTapped(Map<String, dynamic> bySaving) {
  // Anda dapat menggunakan Navigator untuk melakukan navigasi ke halaman yang berbeda.

  String savings_account_id = bySaving['savings_account_id'].toString();

    setState(() {
      this.savings_account_id = savings_account_id;
    });
    print(savings_account_id);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MemberDeposit(bySaving: bySaving, data: 'savings_account_id',),
    ),
  );
}
}