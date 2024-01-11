
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/navbar/bottom_navbar.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/utility/currency_format2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MandatorySavings extends StatefulWidget {

  late Map<String, dynamic> byMandatorySavings;
  final String data;

  MandatorySavings({required this.byMandatorySavings, required  this.data});

  @override
  State<MandatorySavings> createState() => _MandatorySavingsState();
  
}

class _MandatorySavingsState extends State<MandatorySavings> {

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
  late String member_id;
  var memberidJson = [];

  String total_amount= '0';
  num member_mandatory_savings = 0;
  num member_mandatory_savings_last_balance= 0;
  num total = 0;
  num subtotal = 0;

  late num SaldoValue;
  late num SetorValue;


// TextEditingController outputController = TextEditingController();
TextEditingController outputController = TextEditingController();

  // Buat controller untuk TextFormField
TextEditingController _textEditingController = TextEditingController();


TextEditingController savingsTextController = TextEditingController(text: 0.toString());
TextEditingController resultController = TextEditingController();
TextEditingController HasilTextController = TextEditingController(text: 0.toString());
TextEditingController setorController = TextEditingController();
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
    member_id = widget.byMandatorySavings[widget.data].toString();
    
    
    SaldoValue = double.parse(widget.byMandatorySavings['member_mandatory_savings_last_balance']);
    SetorValue = member_mandatory_savings_last_balance;
    savingsTextController.text = CurrencyFormat.convertToIdr(double.parse(widget.byMandatorySavings['member_mandatory_savings_last_balance']), 0).toString();
    // savingsTextController.text = double.parse(widget.byMandatorySavings['member_mandatory_savings']).toString();


      resultController.text = calculateTotal().toString();
      HasilTextController.text = calculateTotal().toString();

      savingsTextController.addListener(onSaldoValueChanged);
      setorController.addListener(onSetorValueChanged);
      onValueChanged(total);
  }

  void onSaldoValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String saldoText = saldoController.text; // Remove 'Rp' and commas
  print('Extracted saldoText: $saldoText'); // Add this line to check the extracted text

  try {
    SaldoValue = double.parse(saldoText);
    
    num total = calculateTotal();
    onValueChanged(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

  void onSetorValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String setorText = setorController.text; // Remove 'Rp' and commas
  print('Extracted setorText: $setorText'); // Add this line to check the extracted text

  try {
    SetorValue = double.parse(setorText);
    
    num total = calculateTotal();
    onValueChanged(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void onValueChanged(total) {
  num total = calculateTotal();
  // Gunakan nilai total untuk memperbarui UI, misalnya:
  setState(() {
    String formattedTotal = CurrencyFormat.convertToIdr(total.toDouble(), 0);
    HasilTextController.text = formattedTotal;
    resultController.text = total.toString();
  });
}

calculateTotal() {
  try {
    // num savingsValue = double.parse(widget.byMandatorySavings['member_mandatory_savings_last_balance']);
    // int integerValue = savingsValue.toInt();
    // widget.byMandatorySavings['member_mandatory_savings_last_balance'] = integerValue.toString();
    
    return   SetorValue + SaldoValue;
  } catch (e) {
    // Handle parsing error, return default value or show an error message
    return SetorValue; // Return default value or handle error
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simp Wajib',style: TextStyle(color: white),),
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
                            initialValue: widget.byMandatorySavings['member_no'],
                            
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
                            initialValue: widget.byMandatorySavings['member_name'],
                            
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
                            initialValue: widget.byMandatorySavings['member_address_now'],
                            
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
                            initialValue: widget.byMandatorySavings['member_identity_no'],
                            
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'No Identitas',
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
                                  controller: savingsTextController,
                                  // initialValue: CurrencyFormat.convertToIdr(double.parse(widget.byMandatorySavings['member_mandatory_savings']), 0).toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {
                                    // widget.byMandatorySavings['member_mandatory_savings'] = int.tryParse(text) ?? 0;
                                    setState(() {
                                    member_mandatory_savings = int.parse(text);
                                  });
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
                            borderRadius:
                            BorderRadius.all(Radius.circular(25).r),
                            color: Colors.grey[200],
                          ),
                            child: TextFormField(
                              controller: setorController,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                  setState(() {
                                    member_mandatory_savings_last_balance = int.parse(text);
                                  });
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
                  postDataToServer(context,member_id);
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

  Future postDataToServer(BuildContext context,String member_id) async {
    final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token')!;
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";

      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.MANDATORYSAVINGS+member_id,
        data: {
          'member_mandatory_savings': double.parse(setorController.text.replaceAll(',', '')),
          'member_mandatory_savings_last_balance':  double.parse(resultController.text),
          'user_id': user_id,
          'member_id': member_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      
      // Check the response status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response

         // Redirect to a new page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  BottomNavBar(initialIndex: 3)), // Gantilah dengan nama halaman redirect yang sesuai
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
        //error
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
