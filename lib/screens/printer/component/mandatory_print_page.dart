import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:jacob_app/screens/style/app_properties.dart';
import 'package:jacob_app/screens/style/custom_background.dart';
import 'package:jacob_app/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../utility/blueprint.dart';
import '../../../utility/currency_format.dart';
import '../../../widget/custom_loading.dart';
import 'no_printer_page.dart';

class MandatoryPrintPage extends StatefulWidget {
  const MandatoryPrintPage({super.key});

  @override
  State<MandatoryPrintPage> createState() => _MandatoryPrintPageState();
}

class _MandatoryPrintPageState extends State<MandatoryPrintPage> {
  String username = '';
  String user_id = '';
  String user_group_name = '';
  String printer_address = '';
  String printer_kitchen_address = '';
  String token = '';
  String member_id = '';
  String start_date = DateTime.now().toString();
  String end_date = DateTime.now().toString();
  late FocusNode myFocusNode;
  bool bluetooth_state = false;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult>? scanResult;
  List<ScanResult>? filteredScanResult;
  int? navbar_index;
  var salesinvoice;
  var company;
  var preferencecompany;
  var expenditure;
  int capital_money_total = 0;
  int expenditure_total = 0;
  int discount_total = 0;
  int ppn_total = 0;
  int sales_subtotal = 0;
  int sales_total = 0;
  int profit = 0;
  int cashier_cash = 0;
  int sales_cash_subtotal = 0;
  int sales_gopay_subtotal = 0;
  int sales_ovo_subtotal = 0;
  int sales_shopeepay_subtotal = 0;
  int sales_others_subtotal = 0;
  int cashier_non_cash = 0;
  int sales_cash_total = 0;
  int sales_non_cash_total = 0;
  int print_status = 0;

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
      token = prefs.getString('token')!;
      printer_address = prefs.getString('printer_address')!;
    });
  }

  void findDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 5));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        if (printer_address.isNotEmpty) {
          scanResult = results
              .where((i) =>
          i.device.name == printer_address)
              .toList();
        }
        scanResult = results;
      });
    });
    flutterBlue.stopScan();
    filteredScanResult = FlutterBlue.instance.scan().where((scanResult) {
      final advertisingData = scanResult.advertisementData;
      final deviceName = scanResult.device.name;
      return (advertisingData.manufacturerData[0x004C] == [0x02, 0x15] ||
          advertisingData.manufacturerData[0x0051] != null) &&
          deviceName.startsWith('Phone');
    }) as List<ScanResult>?;

    setState(() {
      scanResult = filteredScanResult;
      print("Before Filter : ");
      print(filteredScanResult);
    });
  }

  void printWithDevice(BluetoothDevice device) async {
    device.disconnect();
    await device.connect();
    final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
    final printer = BluePrint();
    // print(navbar_index);
    await getSalesPrintData(context);
    // printer.add(gen.qrcode('www.ciptasolutindo.id'));
    printer.add(
      gen.text(
        company['company_name'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );

    printer.add(
      gen.text(
        preferencecompany['branch_name'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );

    printer.add(
      gen.text(
        'WA ' + preferencecompany['branch_phone1'].toString(),
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    
    printer.add(gen.feed(1));

    printer.add(
      gen.row([
        PosColumn(
          text: "Anggota :",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(
      gen.row([
        PosColumn(
          text: salesinvoice['member']['member_name'],
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(gen.feed(1));

    printer.add(
      gen.row([
        PosColumn(
          text: "No Tabungan:",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(
      gen.row([
        PosColumn(
          text: salesinvoice['savingsaccount']['savings_account_no'],
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

        printer.add(gen.feed(1));

    printer.add(
      gen.row([
        PosColumn(
          text: "Jenis Simpanan :",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(
      gen.row([
        PosColumn(
          text: salesinvoice['savings']['savings_name'],
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(gen.feed(1));

    printer.add(
      gen.row([
        PosColumn(
          text: "Total Setor Tunai :",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(
      gen.row([
        PosColumn(
          text: salesinvoice['savings_cash_mutation_amount'] != 0
              ? CurrencyFormat.convertToIdrwithoutSymbol(
              double.parse(salesinvoice['savings_cash_mutation_amount']), 2)
              : "0",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(gen.feed(1));

    printer.add(
      gen.row([
        PosColumn(
          text: "Saldo :",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

    printer.add(
      gen.row([
        PosColumn(
          text: salesinvoice['savingsaccount']['savings_account_last_balance'] != 0
              ? CurrencyFormat.convertToIdrwithoutSymbol(
              double.parse(salesinvoice['savingsaccount']['savings_account_last_balance']), 2)
              : "0",
          width: 12,
          styles: PosStyles(align: PosAlign.left),
        ),
      ]),
    );

      printer.add(gen.feed(1));

    printer.add(
      gen.row([
        PosColumn(
          text: username,
          width: 6,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text:  salesinvoice['savings_cash_mutation_date'].toString(),
          styles: const PosStyles(bold: true, align: PosAlign.right),
          width: 6,
        ),
      ]),
    );
    
    printer.add(gen.feed(3));
    await printer.printData(device);
    device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MainBackground(),
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              'Print',
              style: TextStyle(color: darkGrey),
            ),
            elevation: 0,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (_, constraints) => SingleChildScrollView(
                child: Column(children: [
                  StreamBuilder<BluetoothState>(
                      stream: FlutterBlue.instance.state,
                      initialData: BluetoothState.unknown,
                      builder: (c, snapshot) {
                        final state = snapshot.data;
                        if (state == BluetoothState.on) {
                          return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  width: MediaQuery.of(context).size.width / 1.7,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      findDevices();
                                      printWithDevice(scanResult![2].device);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromRGBO(236, 60, 3, 1),
                                    ),
                                    icon: Icon(
                                      Icons.bluetooth_connected,
                                      color: Colors.white,
                                      size: 12.0,
                                    ),
                                    label: Text('SCAN DEVICE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12)), // <-- Text
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 600.0,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return (scanResult![index].device.name == printer_address) ? Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color(0xffFCE183),
                                                Color(0xffF68D7F),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            trailing: SimpleShadow(
                                              child: Image.asset(
                                                'assets/icons/printer.png',
                                                height: 40,
                                                width: 40,
                                              ),
                                              opacity: 0.6,
                                              color: Colors.black26,
                                              offset: Offset(2, 2),
                                              sigma: 5,
                                            ),
                                            title: Text(
                                                "Printer Kasir : ${scanResult![index].device.name}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)
                                            ),
                                            subtitle: Text(
                                                "MAC Address : ${scanResult![index].device.id.id}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)
                                            ),
                                            onTap: () =>
                                                printWithDevice(scanResult![index].device),
                                          ),
                                        ) : Container();
                                      },
                                      itemCount: scanResult?.length ?? 0),
                                ),
                              ]
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        print(state);
                                        AppSettings.openBluetoothSettings();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromRGBO(236, 60, 3, 1),
                                      ),
                                      icon: Icon(
                                        Icons.bluetooth,
                                        color: Colors.white,
                                        size: 12.0,
                                      ),
                                      label: Text('HIDUPKAN BLUETOOTH',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12)
                                      ),
                                    ),
                                    NoPrinterPage()
                                  ],
                                )
                            ),
                          );
                        }
                      }),
                  SizedBox(height: 20),
                ]),
              ),
            ),
          )
      ),
    );
  }

  Future<void> getSalesPrintData(BuildContext context) async {
    // Remove data for the 'counter' key.
    final prefs = await SharedPreferences.getInstance();
    showLoaderDialog(context);
    token = prefs.getString('token')!;
    member_id = prefs.getString('member_id')!;
    try {
      Response response;
      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer ${token}";
      response = await dio.post(
        AppConstans.BASE_URL+AppConstans.MANDATORYPRINT,
        data: {
          'user_id': user_id == null ? null : user_id,
          'member_id': member_id
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        //berhasil
        hideLoaderDialog(context);
        salesinvoice = response.data['data'];
        preferencecompany = response.data['preferencecompany'];
        company = response.data['company'];

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
        print(user_id);

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
