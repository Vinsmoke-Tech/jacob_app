
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/navbar/bottom_navbar.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:jacob_app/utility/currency_format2.dart';
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
  late String credits_account_id;
  // String credits_account_id= '';
  var memberidJson = [];
  
  num credits_account_principal_amount = 0;
  num credits_account_interest_amount = 0;
  num credits_payment_fine = 0;
  num credits_others_income = 0;
  num member_mandatory_savings = 0;

  late num AngsuranPokok;
  num total = 0;
  late num BungaValue;
  late num DendaValue;
  late num LainValue;
  late num WajibValue;
  




TextEditingController saldoController = TextEditingController();
TextEditingController angsuranController = TextEditingController();
TextEditingController bungaController = TextEditingController();
TextEditingController dendaController = TextEditingController(text: '0');
TextEditingController lainController = TextEditingController();
TextEditingController simpwajibController = TextEditingController();

TextEditingController resultController = TextEditingController();
TextEditingController HasilTextController = TextEditingController(text: 0.toString());

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
    credits_account_id = widget.bySaving[widget.data].toString();

    AngsuranPokok = double.parse(widget.bySaving['credits_account_principal_amount']);
    BungaValue = double.parse(widget.bySaving['credits_account_interest_amount']);
    DendaValue = credits_payment_fine;
    LainValue = credits_others_income;
    WajibValue = member_mandatory_savings;



    angsuranController.text = CurrencyFormat.convertToIdr(double.parse(widget.bySaving['credits_account_principal_amount']), 0).toString();
    bungaController.text = CurrencyFormat.convertToIdr(double.parse(widget.bySaving['credits_account_interest_amount']), 0).toString();

      resultController.text = calculateTotal().toString();
      HasilTextController.text = calculateTotal().toString();

      bungaController.addListener(onBungaValueChanged);
      angsuranController.addListener(onAngsuranValueChanged);
      dendaController.addListener(onDendaValueChanged);
      lainController.addListener(onLainValueChanged);
      simpwajibController.addListener(onSimpWajibValueChanged);
      
      // onBungaValueChanged();
      updateTotalValue(total);

  }

void onBungaValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String bungaText = bungaController.text; // Remove 'Rp' and commas
  print('Extracted bungaText: $bungaText'); // Add this line to check the extracted text

  try {

    //logic null then 0
    if(bungaText.isEmpty){
      BungaValue = 0;
    }else{
      BungaValue = double.parse(bungaText);
    }
    
    num total = calculateTotal();
    updateTotalValue(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void onDendaValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String dendaText = dendaController.text; // Remove 'Rp' and commas
  print('Extracted dendaText: $dendaText'); // Add this line to check the extracted text

  try {

    if (dendaText.isEmpty) {
      DendaValue = 0;
    } else {
      DendaValue = double.parse(dendaText);
    }
    
    num total = calculateTotal();
    updateTotalValue(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void onLainValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String lainText = lainController.text; // Remove 'Rp' and commas
  print('Extracted lainText: $lainText'); // Add this line to check the extracted text

  try {
    LainValue = double.parse(lainText);
    
    num total = calculateTotal();
    updateTotalValue(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void onSimpWajibValueChanged() {
  // Extract the numeric value from the string and parse it into an integer
  String wajibText = simpwajibController.text; // Remove 'Rp' and commas
  print('Extracted wajibText: $wajibText'); // Add this line to check the extracted text

  try {
    WajibValue = double.parse(wajibText);
    
    num total = calculateTotal();
    updateTotalValue(total);
  } catch (e) {
    print('Invalid integer format');
    // Handle the case where the text couldn't be parsed into an integer
  }
}

void onAngsuranValueChanged() {
  // Update AngsuranPokok when the value in the text field changes
  AngsuranPokok = int.parse(angsuranController.text.replaceAll(',', '')); // Remove commas before parsing

  num total = calculateTotal();
  updateTotalValue(total);
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
  return AngsuranPokok + BungaValue + DendaValue + LainValue + WajibValue;
}



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angsuran',style: TextStyle(color: white),),
        backgroundColor: transparentBrown,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
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
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
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
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
              SizedBox(height: 16.h),
        
              Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: widget.bySaving['member_no'],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'No Anggota',
                        labelStyle: TextStyle(
                          color: myFocusNodeFive.hasFocus
                              ? Colors.black
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: angsuranController,
                      // initialValue: CurrencyFormat.convertToIdr(double.parse(widget.bySaving['credits_account_principal_amount']), 0).toString(),
                      keyboardType: TextInputType.number,
                          onChanged: (text) {
                                credits_account_principal_amount = int.parse(text);
                              },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Angsuran Pokok',
                        labelStyle: TextStyle(
                          color: myFocusNodeFive.hasFocus
                              ? Colors.black
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

              SizedBox(height: 16.h),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: bungaController,
                      // initialValue: CurrencyFormat.convertToIdr(double.parse(widget.bySaving['credits_account_interest_amount']), 0).toString(),
                      keyboardType: TextInputType.number,
                          onChanged: (text) {
                              setState(() {
                                credits_account_interest_amount = int.parse(text);
                              });

                              },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Angsuran Bunga',
                        labelStyle: TextStyle(
                          color: myFocusNodeFive.hasFocus
                              ? Colors.black
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: dendaController,
                      keyboardType: TextInputType.number,
                          onChanged: (text) {
                                setState(() {
                                  credits_payment_fine = text.isEmpty ? 0 : int.parse(text);
                                });
                              },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Denda',
                        labelStyle: TextStyle(
                          color: myFocusNodeFive.hasFocus
                              ? Colors.black
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: lainController,
                      keyboardType: TextInputType.number,
                          onChanged: (text) {
                                credits_others_income = int.parse(text);
                              },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Pendapatan Lain',
                        labelStyle: TextStyle(
                          color: myFocusNodeFive.hasFocus
                              ? Colors.black
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey[200],
                    ),
                    child: TextFormField(
                      readOnly: false,
                      controller: simpwajibController,
                      onChanged: (text) {
                                member_mandatory_savings = int.parse(text);
                              },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Simpanan Wajib',
                        labelStyle: TextStyle(
                          color: myFocusNodeFive.hasFocus
                              ? Colors.black
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                  postDataToServer(context,credits_account_id);
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

  Future postDataToServer(BuildContext context,String credits_account_id) async {
    final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token')!;
    try {
      // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";

      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.PAYMENTCASH+credits_account_id,
        data: {
          'angsuran_total'              : double.parse(resultController.text.replaceAll(',', '')),
          'angsuran_pokok'              : double.parse(angsuranController.text.replaceAll('.', '').replaceAll('Rp', '').replaceAll(',', '')),
          'angsuran_bunga'              : double.parse(bungaController.text.replaceAll('.', '').replaceAll('Rp', '').replaceAll(',', '')),
          'others_income'               : lainController.text,
          'credits_payment_fine_amount' : dendaController.text,
          'member_mandatory_savings'    : simpwajibController.text,
          'user_id'                     : user_id,
          'credits_account_id'          : credits_account_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      
      // Check the response status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response

         // Redirect to a new page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  BottomNavBar(initialIndex: 2)), // Gantilah dengan nama halaman redirect yang sesuai
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
