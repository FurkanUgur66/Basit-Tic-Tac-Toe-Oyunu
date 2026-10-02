import 'package:flutter/material.dart';
import 'oyun_sayfasi.dart';

class ZorluklarSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Zorluk Seç'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Zorluk Derecesi',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            
            // --- Kolay Mod Butonu ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(220, 55),
              ),
              onPressed: () {
                // Oyun sayfasına 'yz_kolay' parametresini ileterek gider.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OyunSayfasi(mod: 'yz_kolay'),
                  ),
                );
              },
              child: Text(
                'Kolay',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            
            // --- Orta Mod Butonu ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(220, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OyunSayfasi(mod: 'yz_orta'),
                  ),
                );
              },
              child: Text(
                'Orta',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            
            // --- Zor Mod Butonu ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(220, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OyunSayfasi(mod: 'yz_zor'),
                  ),
                );
              },
              child: Text(
                'Zor',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}