
import 'package:flutter/material.dart';
import 'oyun_sayfasi.dart';
import 'zorluklar_sayfasi.dart';

class AnaSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Furkan Uğur',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
           
            SizedBox(height: 10),
            Text(
              'Tic Tac Toe',
              style: TextStyle(
                fontSize: 40,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Bir mod seçin',
              style: TextStyle(
                fontSize: 20, 
                color: Colors.grey
              ),
            ),
            SizedBox(height: 50),
            
            // --- İki Kişilik Mod Butonu ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(220, 55),
              ),
              onPressed: () {
                // Butona tıklandığında OyunSayfasi'na yönlendirir ve mod olarak 'iki_kisi' bilgisini gönderir.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OyunSayfasi(mod: 'iki_kisi'),
                  ),
                );
              },
              child: Text(
                'İki Kişilik',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            
            // --- Yapay Zekaya Karşı Butonu ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(220, 55),
              ),
              onPressed: () {
                // Doğrudan oyuna değil, zorluk seçme ekranına (ZorluklarSayfasi) yönlendirir.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZorluklarSayfasi(),
                  ),
                );
              },
              child: Text(
                'Yapay Zekaya Karşı',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}