import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jacob_app/screens/homepage/deposit_page.dart';
import 'package:jacob_app/screens/homepage/installments_page.dart';
import 'package:jacob_app/screens/homepage/mandatory_savings_page.dart';
import 'package:jacob_app/screens/homepage/withdraw_page.dart';
import 'package:jacob_app/screens/profile/setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({Key? key, required this.initialIndex}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState(initialIndex);
}

class _BottomNavBarState
    extends State<BottomNavBar> {
  int _currentIndex = 0;

  _BottomNavBarState(this._currentIndex);
  String username = '';
  String user_id = '';
  String token = '';


  @override
  void initState() {
    super.initState();
    loadSharedPreference();
  }

  loadSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    
      setState(() {
      username = prefs.getString('username')?? '';
      user_id = prefs.getString('user_id')?? '';
      token = prefs.getString('token')?? '';
    });
  }
  
  final List<Widget> _screens = [
    HomePage(),
    WithdrawPage(),
    InstallmentsPage(),
    MandatorySavingsPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(child: _screens[_currentIndex],),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13.sp,
        unselectedFontSize: 12.sp,
        elevation: 0.0,
        items:  <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/money-box.png',
              width: 22.w, // Set the desired width
              height: 22.h,
              fit: BoxFit.fill, // Set the desired height
            ),
            label: 'Setor Tunai',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/withdraw.png',
              width: 22.w, // Set the desired width
              height: 22.h,
              fit: BoxFit.fill, // Set the desired height
            ),
            label: 'Tarik Tunai',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/angsuran.png',
              width: 22.w, // Set the desired width
              height: 22.h,
              fit: BoxFit.fill,  // Set the desired height
            ),
            label: 'Angsuran',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/ledger.png',
              width: 22.w, // Set the desired width
              height: 22.h,
              fit: BoxFit.fill,  // Set the desired height
            ),
            label: 'Simp. Wajib',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/settings_icon.png',
              width: 22.w, // Set the desired width
              height: 22.h,
              fit: BoxFit.fill,// Set the desired height
            ),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

