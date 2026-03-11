class PenyakitInfo {
  final String namaTampil;
  final List<String> gejala;
  final List<String> pengendalian;

  const PenyakitInfo({
    required this.namaTampil,
    required this.gejala,
    required this.pengendalian,
  });
}

const Map<String, PenyakitInfo> penyakitCabaiMap = {
  'bakteri': PenyakitInfo(
    namaTampil: 'Bercak Bakteri (Bacterial Leaf Spot)',
    gejala: [
      'Muncul bercak kecil pada daun yang kemudian menjadi coklat atau kehitaman.',
      'Bercak dapat menyebar dan menyebabkan jaringan daun rusak.',
      'Penyakit sering berkembang saat cuaca hangat dan lembab serta terdapat embun pada daun.',
    ],
    pengendalian: [
      'Menggunakan benih sehat dan bebas penyakit.',
      'Sanitasi tanaman sakit atau sisa tanaman yang terinfeksi.',
      'Menghindari kondisi daun terlalu lembab.',
      'Jika diperlukan dapat menggunakan bakterisida sesuai anjuran.',
    ],
  ),
  'serkospora': PenyakitInfo(
    namaTampil: 'Bercak Serkospora (Cercospora Leaf Spot)',
    gejala: [
      'Muncul bercak bulat coklat pada daun dengan pusat bercak berwarna pucat atau putih.',
      'Bercak dapat menyebabkan lubang pada daun dan akhirnya daun rontok.',
      'Serangan berat dapat menyebabkan tanaman kehilangan banyak daun sehingga produksi menurun.',
    ],
    pengendalian: [
      'Sanitasi tanaman dan sisa tanaman yang terinfeksi.',
      'Menggunakan bibit bebas patogen.',
      'Perbaikan drainase dan menghindari kelembaban berlebih.',
      'Rotasi tanaman dengan tanaman non-solanaceae.',
      'Penggunaan fungisida jika serangan berat.',
    ],
  ),
  'kutu': PenyakitInfo(
    namaTampil: 'Kutu Kebul (Whitefly)',
    gejala: [
      'Daun mengalami bercak nekrotik akibat hisapan serangga.',
      'Tanaman tumbuh terhambat jika populasi tinggi.',
      'Menghasilkan embun madu yang menyebabkan jamur jelaga hitam pada daun.',
      'Berperan sebagai vektor berbagai virus tanaman termasuk geminivirus.',
    ],
    pengendalian: [
      'Pemanfaatan musuh alami seperti kumbang predator dan parasitoid.',
      'Perangkap warna kuning untuk menangkap serangga.',
      'Sanitasi lingkungan dan rotasi tanaman.',
      'Penanaman tanaman perangkap seperti Tagetes atau jagung.',
      'Insektisida selektif jika populasi sangat tinggi.',
    ],
  ),
  'mosaik': PenyakitInfo(
    namaTampil: 'Mosaik (Leaf Curl Virus)',
    gejala: [
      'Daun mengalami perubahan warna menjadi mosaik atau belang.',
      'Daun mengeriting atau menggulung.',
      'Tanaman tumbuh kerdil dan produksi menurun.',
      'Virus sering ditularkan oleh serangga vektor seperti kutu daun atau thrips.',
    ],
    pengendalian: [
      'Mengendalikan vektor serangga seperti kutu daun dan thrips.',
      'Sanitasi tanaman terinfeksi.',
      'Menggunakan bibit sehat dan persemaian bebas virus.',
      'Mengurangi populasi gulma yang menjadi inang virus.',
    ],
  ),
  'geminivirus': PenyakitInfo(
    namaTampil: 'Geminivirus (Yellow Leaf Curl)',
    gejala: [
      'Daun muda mengalami vein clearing lalu menguning.',
      'Tulang daun menebal dan daun menggulung ke atas.',
      'Daun menjadi kecil dan kuning terang.',
      'Tanaman kerdil dan tidak menghasilkan buah.',
    ],
    pengendalian: [
      'Mengendalikan vektor kutu kebul (Bemisia tabaci).',
      'Menggunakan varietas tahan virus.',
      'Sanitasi gulma dan tanaman inang di sekitar lahan.',
      'Penggunaan mulsa plastik untuk mengurangi populasi vektor.',
      'Menanam tanaman pembatas seperti jagung atau tagetes.',
    ],
  ),
  'sehat': PenyakitInfo(
    namaTampil: 'Daun Sehat (Healthy)',
    gejala: [
      'Daun berwarna hijau normal.',
      'Tidak terdapat bercak, mosaik, keriting, atau nekrosis.',
      'Pertumbuhan daun tampak normal.',
    ],
    pengendalian: [
      'Lanjutkan perawatan rutin tanaman.',
      'Jaga sanitasi lahan.',
      'Lakukan pemantauan berkala untuk deteksi dini.',
    ],
  ),
};