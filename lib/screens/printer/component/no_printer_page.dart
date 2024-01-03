import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class NoPrinterPage extends StatelessWidget {
  const NoPrinterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: SimpleShadow(
              child: Image.asset(
                'assets/icons/printer.png',
                height: 150,
                width: 150,
              ),
              opacity: 0.6,
              color: Colors.black26,
              offset: Offset(2, 2),
              sigma: 5,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Pastikan bluetooth perangkat & printer anda dalam keadaan aktif. pastikan juga untuk memasukkan nama perangkat printer anda kedalam pengaturan printer',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
