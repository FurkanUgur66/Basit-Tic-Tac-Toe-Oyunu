import 'package:flutter/material.dart';
import 'dart:math';

class OyunSayfasi extends StatefulWidget {
  final String mod; // Dışarıdan ('iki_kisi', 'yz_kolay', vb.) gelen mod bilgisini tutar.

  OyunSayfasi({required this.mod});

  @override
  _OyunSayfasiState createState() => _OyunSayfasiState();
}

class _OyunSayfasiState extends State<OyunSayfasi> {
  // Oyun tahtası
  List<String> tahta = ['', '', '', '', '', '', '', '', ''];

  // Sıranın kimde olduğunu tutan değişken
  bool xSirasi = true;

  // Oyun durumu
  bool oyunBitti = false;

  // Ekranda gösterilecek mesaj
  String mesaj = '';

  // Kolay mod için rastgele sayı üreticisi
  Random rastgele = Random();

  @override
  void initState() {
    super.initState();
    mesaj = _siraMesaji();
  }

  // --- OYUN MANTIĞI VE YARDIMCI FONKSİYONLAR ---

  String _siraMesaji() {
    if (widget.mod == 'iki_kisi') {
      return xSirasi ? "X'in sırası" : "O'nun sırası";
    } else {
      return xSirasi ? 'Senin sıran (X)' : 'YZ düşünüyor...';
    }
  }

  
  // Tahtadaki 8 olası kazanma kombinasyonunu (satır, sütun, çapraz) tek tek tarar.
  String _kazananBul(List<String> t) {
    List<List<int>> kombinasyonlar = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Satırlar
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Sütunlar
      [0, 4, 8], [2, 4, 6],            // Çaprazlar
    ];

    for (var kombo in kombinasyonlar) {
      String a = t[kombo[0]];
      String b = t[kombo[1]];
      String c = t[kombo[2]];
      
      if (a != '' && a == b && b == c) {
        return a;
      }
    }
    return ''; 
  }

  bool _tahtaDolu(List<String> t) {
    return t.every((hucre) => hucre != '');
  }

  // --- OYUNCU ETKİLEŞİMİ ---

  void _tikla(int index) {
    if (tahta[index] != '' || oyunBitti) return;

    if (widget.mod != 'iki_kisi' && !xSirasi) return;

    setState(() {
      tahta[index] = xSirasi ? 'X' : 'O'; 

      String kazanan = _kazananBul(tahta);
      if (kazanan != '') {
        oyunBitti = true;
        if (widget.mod == 'iki_kisi') {
          mesaj = '$kazanan kazandı';
        } else {
          mesaj = kazanan == 'X' ? 'Sen kazandın' : 'YZ kazandı';
        }
        return; 
      }

      if (_tahtaDolu(tahta)) {
        oyunBitti = true;
        mesaj = 'Beraberlik';
        return; 
      }

      xSirasi = !xSirasi;
      mesaj = _siraMesaji();
    });

    if (widget.mod != 'iki_kisi' && !xSirasi && !oyunBitti) {
      Future.delayed(Duration(milliseconds: 500), () {
        _yzHamleYap();
      });
    }
  }

  // --- YAPAY ZEKA ALGORİTMALARI ---

  void _yzHamleYap() {
    int secilenHucre = -1;

    if (widget.mod == 'yz_kolay') {
      secilenHucre = _koLayHamle();
    } else if (widget.mod == 'yz_orta') {
      secilenHucre = _ortaHamle();
    } else if (widget.mod == 'yz_zor') {
      secilenHucre = _zorHamle();
    }

    if (secilenHucre == -1) return;

    setState(() {
      tahta[secilenHucre] = 'O';

      String kazanan = _kazananBul(tahta);
      if (kazanan != '') {
        oyunBitti = true;
        mesaj = kazanan == 'X' ? 'Sen kazandın' : 'YZ kazandı';
        return;
      }

      if (_tahtaDolu(tahta)) {
        oyunBitti = true;
        mesaj = 'Beraberlik';
        return;
      }

      xSirasi = true; 
      mesaj = 'Senin sıran (X)';
    });
  }

  // ALGORİTMA (Kolay Mod): Rastgele Seçim
  // Boş olan hücreleri bir listeye alır ve içinden rastgele birini seçer.
  int _koLayHamle() {
    List<int> bosHucreler = [];
    for (int i = 0; i < 9; i++) {
      if (tahta[i] == '') bosHucreler.add(i);
    }
    if (bosHucreler.isEmpty) return -1;
    return bosHucreler[rastgele.nextInt(bosHucreler.length)];
  }

  // ALGORİTMA (Orta Mod): İleri Bak ve Değerlendir
  // Önce kazanabiliyor mu diye bakar, sonra rakip kazanacaksa engeller, yoksa rastgele atar.
  int _ortaHamle() {
    for (int i = 0; i < 9; i++) {
      if (tahta[i] == '') {
        List<String> gecici = List.from(tahta);
        gecici[i] = 'O';
        if (_kazananBul(gecici) == 'O') return i; 
      }
    }

    for (int i = 0; i < 9; i++) {
      if (tahta[i] == '') {
        List<String> gecici = List.from(tahta);
        gecici[i] = 'X';
        if (_kazananBul(gecici) == 'X') return i; 
      }
    }

    if (tahta[4] == '') return 4;

    return _koLayHamle();
  }

  // ALGORİTMA (Zor Mod): Minimax Algoritmasını Başlatan Fonksiyon
  // YZ için en kazançlı hamleyi bulmak üzere tüm olasılık ağacını başlatır.
  int _zorHamle() {
    int enIyiPuan = -1000;
    int enIyiHucre = -1;

    for (int i = 0; i < 9; i++) {
      if (tahta[i] == '') {
        List<String> gecici = List.from(tahta);
        gecici[i] = 'O';
        int puan = _alphaBeta(gecici, 0, false, -1000, 1000);
        if (puan > enIyiPuan) {
          enIyiPuan = puan;
          enIyiHucre = i;
        }
      }
    }
    return enIyiHucre; 
  }

  // ALGORİTMA: Minimax with Alpha-Beta Pruning
  // Karar ağacı oluşturarak oyun sonuna kadar tüm ihtimalleri hesaplar ve yenilmez bir YZ oluşturur.
  int _alphaBeta(List<String> t, int derinlik, bool maxOyuncu, int alpha, int beta) {
    String kazanan = _kazananBul(t);

    if (kazanan == 'O') return 10 - derinlik; // YZ kazanırsa yüksek puan
    if (kazanan == 'X') return derinlik - 10; // Kullanıcı kazanırsa YZ için düşük puan (-10 tabanlı)
    if (_tahtaDolu(t)) return 0;              // Beraberlik durumu (0 puan)

    if (maxOyuncu) {
      int enIyi = -1000;
      for (int i = 0; i < 9; i++) {
        if (t[i] == '') {
          List<String> gecici = List.from(t);
          gecici[i] = 'O';
          int puan = _alphaBeta(gecici, derinlik + 1, false, alpha, beta);
          if (puan > enIyi) enIyi = puan;
          if (puan > alpha) alpha = puan;
          if (alpha >= beta) break;  //Budama yapar.
        }
      }
      return enIyi;
    } else {
      int enIyi = 1000;
      for (int i = 0; i < 9; i++) {
        if (t[i] == '') {
          List<String> gecici = List.from(t);
          gecici[i] = 'X';
          int puan = _alphaBeta(gecici, derinlik + 1, true, alpha, beta);
          if (puan < enIyi) enIyi = puan;
          if (puan < beta) beta = puan;
          if (alpha >= beta) break; 
        }
      }
      return enIyi;
    }
  }

  void _sifirla() {
    setState(() {
      tahta = ['', '', '', '', '', '', '', '', ''];
      xSirasi = true;
      oyunBitti = false;
      mesaj = _siraMesaji();
    });
  }

  String _modBasligi() {
    switch (widget.mod) {
      case 'iki_kisi': return 'İki Kişilik';
      case 'yz_kolay': return 'Kolay Mod';
      case 'yz_orta': return 'Orta Mod';
      case 'yz_zor': return 'Zor Mod';
      default: return 'Oyun';
    }
  }

  // --- ARAYÜZ OLUŞTURMA ---

  @override
  Widget build(BuildContext context) {
    Color mesajRengi = Colors.black; 
    
    if (mesaj.contains('X') || mesaj.contains('Senin')) {
      mesajRengi = Colors.blue;  
    } else if (mesaj.contains('O') || mesaj.contains('YZ')) {
      mesajRengi = Colors.red;   
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_modBasligi()),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Oyun Durum Mesajı
            Text(
              mesaj,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mesajRengi, 
              ),
            ),
            SizedBox(height: 30),

            // Oyun Tahtası
            Container(
              width: 300,
              height: 300,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(), 
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, 
                ),
                itemCount: 9, 
                itemBuilder: (context, index) {
                  return _hucreOlustur(index);
                },
              ),
            ),

            SizedBox(height: 30),

            // Tekrar Oyna Butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(180, 50),
              ),
              onPressed: _sifirla, 
              child: Text(
                'Tekrar Oyna',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Oyun tahtasındaki tek bir kareyi çizen fonksiyon.
  Widget _hucreOlustur(int index) {
    String deger = tahta[index];

    Color renk = const Color.fromARGB(255, 217, 209, 209);
    Color yaziRengi = Colors.black;
    if (deger == 'X') yaziRengi = Colors.blue;
    if (deger == 'O') yaziRengi = Colors.red;

    // Tıklama Algılayıcı. Container'ı butona dönüştürür.
    return GestureDetector(
      onTap: () => _tikla(index), 
      child: Container(
        margin: EdgeInsets.all(4), 
        decoration: BoxDecoration(
          color: renk,
          borderRadius: BorderRadius.circular(8), 
          border: Border.all(color: const Color.fromARGB(255, 217, 209, 209), width: 1), 
        ),
        child: Center(
          child: Text(
            deger, 
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: yaziRengi,
            ),
          ),
        ),
      ),
    );
  }
}