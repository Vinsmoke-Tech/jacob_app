
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/utility/currency_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InsertInstallments extends StatefulWidget {

  late Map<String, dynamic> bySaving;
  final String data;

  InsertInstallments({required this.bySaving, required  this.data});

  @override
  State<InsertInstallments> createState() => _InsertInstallmentsState();
  
}

class _InsertInstallmentsState extends State<InsertInstallments> {

  late FocusNode myFocusNode;
  late FocusNode myFocusNodeTwo;
  late FocusNode myFocusNodeThree;
  late FocusNode myFocusNodeFour;
  late FocusNode myFocusNodeFive;
  late FocusNode myFocusNodeSix;
  late bool obscureText;
  String token = '';
  String user_id = '';
  String savingsaccount ='';
  String memberid ='';
  late String savings_account_id;
  String savings_cash_mutation_amount= '';
  var memberidJson = [];



TextEditingController saldoController = TextEditingController();
    @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNodeTwo = FocusNode();
    myFocusNodeThree = FocusNode();
    myFocusNodeFour = FocusNode();
    myFocusNodeFive = FocusNode();
    myFocusNodeSix = FocusNode();
    obscureText = true;
    savings_account_id = widget.bySaving[widget.data].toString();


  // Assuming widget.bySaving['savings_account_last_balance'] is a String
  // String formattedSaldo = CurrencyFormat.convertToIdr(
  //   double.parse(widget.bySaving ['savings_account_last_balance']),
  //   0,
  //   initialValue: widget.bySaving['savings_account_last_balance'],
  // );
  // saldoController.text = formattedSaldo;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setor Tunai',style: TextStyle(color: white),),
        backgroundColor: transparentBrown,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25).r),
                            color: Colors.grey[200],  
                          ),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: widget.bySaving['credits_name'],
                            
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Jenis Pinjaman',
                              labelStyle: TextStyle(
                                  color: myFocusNodeFive.hasFocus
                                      ? Colors.black
                                      : blue
                              ),
                            ),
                          ),
                        ),
              SizedBox(height: 16.h),
        
              Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.r)),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: widget.bySaving['member_name'],
                            
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Nama Anggota',
                              labelStyle: TextStyle(
                                  color: myFocusNodeFive.hasFocus
                                      ? Colors.black
                                      : blue
                              ),
                            ),
                          ),
                        ),
              SizedBox(height: 16.h),
                        
              Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25).r),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: widget.bySaving['member_address_now'],
                            
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Alamat',
                              labelStyle: TextStyle(
                                  color: myFocusNodeFive.hasFocus
                                      ? Colors.black
                                      : blue
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
              Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.r)),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: widget.bySaving['member_identity_no'],
                            
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'No Anggota',
                              labelStyle: TextStyle(
                                  color: myFocusNodeFive.hasFocus
                                      ? Colors.black
                                      : blue
                              ),
                            ),
                          ),
                        ),
        
                        SizedBox(height: 16.h),
              Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.r)),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  // controller: saldoController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Saldo Akhir',
                                    labelStyle: TextStyle(
                                        color: myFocusNodeFive.hasFocus
                                            ? Colors.black
                                            : blue
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16.h),
              Container(
                          padding: EdgeInsets.only(left: 16.w),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25).r),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                                  savings_cash_mutation_amount = text;
                                },
                            readOnly: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Jumlah (Rp)',
                              labelStyle: TextStyle(
                                  color: myFocusNodeFive.hasFocus
                                      ? Colors.black
                                      : blue
                                      
                              ),
                            ),
                          ),
                        ),
        
        
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  // Process to send data to the server
                  postDataToServer(context,savings_account_id);
                },
                style: ElevatedButton.styleFrom(
                  primary: transparentBrown,
                  foregroundColor: white,
                  elevation: 7, // Warna latar belakang tombol
                  shadowColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text('SIMPAN', style: TextStyle(fontSize: 18.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future postDataToServer(BuildContext context,String savings_account_id) async {
    final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token')!;
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";

      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.DEPOSITBYID+savings_account_id,
        data: {
          'savings_cash_mutation_amount': savings_cash_mutation_amount,
          'user_id': user_id,
          'savings_account_id': savings_account_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      
      // Check the response status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response

         // Redirect to a new page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Gantilah dengan nama halaman redirect yang sesuai
          );
          // Navigator.pop(context);
      } 
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        // ignore: unused_local_variable
        String errorMessage = e.response?.data['message'];
        
      } else {
        print(e);
        _showDialog(context, 'Terjadi kesalahan. Silakan coba lagi.');
      }
    }
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Teks yang Dimasukkan'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
  }