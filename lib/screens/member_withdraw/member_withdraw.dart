
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/homepage/withdraw_page.dart';
import 'package:jacob_app/screens/navbar/bottom_navbar.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/utility/currency_format2.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MemberWithdraw extends StatefulWidget {

  late Map<String, dynamic> bySaving;
  final String data;

  MemberWithdraw({required this.bySaving, required  this.data});

  @override
  State<MemberWithdraw> createState() => _MemberWithdrawState();
  
}

class _MemberWithdrawState extends State<MemberWithdraw> {

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
  var memberidJson = [];

  num savings_cash_mutation_amount= 0;
  num savings_account_last_balance= 0;
  num savings_cash_mutation_amount_adm= 0;

  num total = 0;
  late num SetorValue;
  late num SaldoValue;
  late num BiayaAdminValue;


TextEditingController saldoController     = TextEditingController();
TextEditingController setorController   = TextEditingController(text: '0');
TextEditingController biayaadmController  = TextEditingController(text: '0');

// hasil yang disimpan di database
TextEditingController resultController    = TextEditingController();

// hasil yang ditampilkan di textformfield
TextEditingController HasilTextController = TextEditingController(text: 0.toString());


    @override
  void initState() {
      super.initState();
      myFocusNode         = FocusNode();
      myFocusNodeTwo      = FocusNode();
      myFocusNodeThree    = FocusNode();
      myFocusNodeFour     = FocusNode();
      myFocusNodeFive     = FocusNode();
      myFocusNodeSix      = FocusNode();
      obscureText         = true;
      savings_account_id  = widget.bySaving[widget.data].toString();

      SaldoValue = double.parse(widget.bySaving['savings_account_last_balance']);
      SetorValue = savings_cash_mutation_amount;

      saldoController.text = CurrencyFormat.convertToIdr(double.parse(widget.bySaving['savings_account_last_balance']), 0).toString();

        resultController.text     = calculateTotal().toString();
        HasilTextController.text  = calculateTotal().toString();

        setorController.addListener(onSetorValueChanged);
        saldoController.addListener(onSaldoValueChanged);
        updateTotalValue(total);
  }

void onSetorValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String setorText = setorController.text; // Remove 'Rp' and commas
  print('Extracted setorText: $setorText'); // Add this line to check the extracted text

  try {
    //logic null then 0
    if (setorText.isEmpty) {
      SetorValue = 0;
    } else {
      SetorValue = double.parse(setorText);
      
    }
    
    //total SUM
    num total = calculateTotal();
    updateTotalValue(total);

  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void onSaldoValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String saldoText = saldoController.text; // Remove 'Rp' and commas
  print('Extracted saldoText: $saldoText'); // Add this line to check the extracted text

  try {
    //logic null then 0
    if (saldoText.isEmpty) {
      SaldoValue = 0;
    } else {
      SaldoValue = double.parse(saldoText);
    }
    
    //total SUM
    num total = calculateTotal();
    updateTotalValue(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void updateTotalValue(num total) {
  num total = calculateTotal();
  setState(() {
    String formattedTotal = CurrencyFormat.convertToIdr(total.toInt(), 0);
    HasilTextController.text = formattedTotal;
    resultController.text = total.toString();
  });
}

num calculateTotal() {
  return SaldoValue - SetorValue;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarik Tunai',style: TextStyle(color: white),),
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
                            initialValue: widget.bySaving['member']['member_no'],
                            
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
                          child: TextFormField(
                            readOnly: true,
                            initialValue: widget.bySaving['member']['member_name'],
                            
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
                            initialValue: widget.bySaving['member']['member_address_now'],
                            
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
                            initialValue: widget.bySaving['member']['member_identity_no'],
                            
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
                                  controller: saldoController,
                                  onChanged: (text) {
                                      savings_account_last_balance  = text.isEmpty ? 0 : int.parse(text);
                                    },
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
                          borderRadius: BorderRadius.all(Radius.circular(25).r),
                          color: Colors.grey[200],
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: setorController,
                          onChanged: (text) {
                            checkAndSetMutationAmount(text);
                          },
                          readOnly: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Jumlah (Rp)',
                            labelStyle: TextStyle(
                              color: myFocusNodeFive.hasFocus ? Colors.black : blue,
                            ),
                          ),
                        ),
                      ),
              SizedBox(height: 16.h),
              Container(
                        padding: EdgeInsets.only(left: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25).r),
                          color: Colors.grey[200],
                        ),
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: biayaadmController,
                            onChanged: (text) {
                                      savings_cash_mutation_amount_adm = text.isEmpty ? 0 : int.parse(text);
                                  },
                          readOnly: false,
                          maxLines: null, // Set to null for a multi-line input
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Biaya Adm',
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
                    borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    color: Colors.grey[200],
                    
                  ),
                    child: TextFormField(
                      controller: HasilTextController,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                                onChanged: (text) {
                                    setState(() {
                                    calculateTotal();
                                  });
                                },
                                  
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Total',
                      labelStyle: TextStyle(
                        color: myFocusNodeFive.hasFocus ? Colors.black : blue,
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

    //logika pengurangan saldo
    late double savingsAccountLastBalance = double.parse(widget.bySaving['savings_account_last_balance']);

    void checkAndSetMutationAmount(String text) {
        setState(() {
          try {
            savings_cash_mutation_amount = double.parse(text);

            if (savings_cash_mutation_amount > savingsAccountLastBalance) {
              _showDialog(context, 'Saldo tidak mencukupi');
              return;
            }
          } catch (e) {
            // Handle the case where the input text is not a valid double
            savings_cash_mutation_amount = 0; // or any other handling you want
          }
        });
    }
    //end

  Future postDataToServer(BuildContext context,String savings_account_id) async {
    final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token')!;
    try {
      if (savings_cash_mutation_amount > savingsAccountLastBalance) {
        _showDialog(context, 'Saldo tidak mencukupi');
        return;
      }
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";

      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.WITHDRAWBYID+savings_account_id,
        data: {
          'savings_cash_mutation_amount': savings_cash_mutation_amount,
          'savings_cash_mutation_amount_adm'  : savings_cash_mutation_amount_adm,
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
            MaterialPageRoute(builder: (context) =>  BottomNavBar(initialIndex: 1)), // Gantilah dengan nama halaman redirect yang sesuai
          );

            //notif berhasil simpan
            _onWidgetDidBuild(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tarik Tunai Berhasil di Simpan'),
                backgroundColor: Color(0xff36E892),
                behavior: SnackBarBehavior.floating,
              ),
            );
          });
      } 
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        //gagal
        // ignore: unused_local_variable
        String errorMessage = e.response?.data['message'];
        
        
      }else if(e.response?.statusCode == 302 || e.response?.statusCode == 302) {
        //gagal
        // ignore: unused_local_variable
        _showDialog(context, 'Saldo tidak mencukupi');
        
      }else{
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
          title: Text('Pesan'),
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

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
