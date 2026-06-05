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
  'Bercak Bakteri': PenyakitInfo(
    namaTampil: 'Bercak Bakteri (Bacterial Leaf Spot)',
    gejala: [
      'Disebabkan oleh Xanthomonas campestris pv. vesicatoria. Gejala pada daun berupa bercak kecil berbentuk bulat/sirkuler, awalnya seperti spot berair, lalu berubah menjadi nekrotik/coklat. Pada permukaan atas daun bercak tampak seperti tenggelam, sedangkan bagian bawah tampak menonjol. Jika parah, bercak menyatu dan daun dapat gugur/defoliasi. Pada buah dapat muncul bercak seperti kutil bulat tidak beraturan dan keras.',
    ],
    pengendalian: [
      'Gunakan benih sehat/bersertifikat, lakukan sanitasi lahan, buang sisa tanaman sakit, lakukan rotasi tanaman, musnahkan tanaman muda yang sudah terinfeksi berat, dan bila perlu gunakan bakterisida/fungisida berbahan tembaga sesuai anjuran.',
    ],
  ),
  'Bercak Serkospora': PenyakitInfo(
    namaTampil: 'Bercak Serkospora (Cercospora Leaf Spot)',
    gejala: [
      'Disebabkan oleh Cercospora capsici / Cercospora sp.. Gejala berupa bercak kecil bulat dan kering pada daun. Pada sumber Balai Penelitian Tanaman Sayuran, bercak disebut menyerupai mata kodok/frog eyes, bagian tengah bercak abu-abu tua/kering, tepi bercak coklat, daun cepat menguning sebelum waktunya, lalu bisa rontok/gugur. Pada serangan berat, tanaman dapat kehilangan banyak daun.',
    ],
    pengendalian: [
      'Lakukan sanitasi dengan membuang dan memusnahkan daun/sisa tanaman terinfeksi, gunakan benih bebas patogen, perbaiki drainase, pilih waktu tanam yang sesuai, lakukan rotasi dengan tanaman non-solanaceae, dan jika serangan tidak terkendali gunakan fungisida berbahan aktif difenoconazole seperti Score 250 EC 0,5 ml/liter dengan interval 7 hari sesuai anjuran.',
    ],
  ),
  'Kutu Kebul': PenyakitInfo(
    namaTampil: 'Kutu Kebul (Whitefly)',
    gejala: [
      'Disebabkan oleh hama sekaligus vektor virus, terutama virus kuning/gemini. Imago berukuran kecil sekitar 1-1,5 mm, berwarna putih, sayap seperti tertutup lilin/tepung sehingga saat terbang tampak seperti “kebul putih”. Serangan pada daun menimbulkan bercak nekrotik akibat isapan nimfa dan serangga dewasa. Populasi tinggi dapat menghambat pertumbuhan tanaman. Kutu kebul juga menghasilkan embun madu yang dapat memicu jamur jelaga hitam, sehingga fotosintesis terganggu.',
    ],
    pengendalian: [
      'Pasang perangkap lekat kuning, gunakan kelambu di persemaian, tanam tanaman penghalang/barrier seperti jagung, orok-orok, tagetes, atau kacang panjang, lakukan rotasi tanaman bukan inang virus, musnahkan sisa tanaman terserang, manfaatkan musuh alami seperti Menochilus sexmaculatus, Encarsia formosa, atau jamur entomopatogen seperti Beauveria bassiana, dan gunakan insektisida terdaftar bila populasi tinggi.',
    ],
  ),
  'Mosaik': PenyakitInfo(
    namaTampil: 'Mosaik (Leaf Curl)',
    gejala: [
      'Disebabkan beberapa virus seperti CMV, TMV, CVMV, PVY, TEV, ToMV, dan juga bisa berkaitan dengan Pepper leaf curl geminivirus. Gejala umum: daun tampak belang hijau muda dan hijau tua, tulang daun menguning atau muncul jalur kuning sepanjang tulang daun, daun menjadi lebih kecil, sempit, kadang cekung, keriting, menggulung, atau memanjang. Tanaman muda yang terserang biasanya kerdil, pertumbuhan tidak normal, cabang/batang terhambat, dan buah bisa lebih kecil.',
    ],
    pengendalian: [
      'Cabut dan musnahkan tanaman yang sudah menunjukkan gejala berat, terutama tanaman muda. Kendalikan vektor seperti kutu daun, thrips, dan kutu kebul, pasang perangkap kuning, gunakan mulsa plastik perak atau jerami sesuai kondisi lahan, lakukan sanitasi gulma/inang sekitar, gunakan benih sehat, serta hindari mengambil benih dari tanaman bergejala.',
    ],
  ),
  'Virus Gemini': PenyakitInfo(
    namaTampil: 'Virus Gemini (Yellow Leaf Curl)',
    gejala: [
      'Disebabkan kelompok Geminivirus, sering dikaitkan dengan TYLCV / Tomato Yellow Leaf Curl Virus dan ditularkan oleh kutu kebul (Bemisia tabaci). Gejala awal: daun muda/pucuk mengalami vein clearing, pucuk tampak cekung/mengkerut, muncul mosaik kuning ringan. Gejala lanjut: daun menjadi kuning cerah/kuning terang, tulang daun menebal, daun menggulung ke atas, daun mengecil, tanaman kerdil, dan pada infeksi berat tanaman bisa tidak berbuah.',
    ],
    pengendalian: [
      'Gunakan benih sehat, tutup persemaian dengan kelambu/kasa, pasang perangkap lekat kuning, lakukan sanitasi gulma/inang alternatif, cabut dan musnahkan tanaman sakit, tanam barrier seperti jagung/tagetes/orok-orok/kacang panjang, lakukan rotasi dengan tanaman bukan Solanaceae/Cucurbitaceae, serta kendalikan kutu kebul dengan musuh alami atau insektisida yang terdaftar.',
    ],
  ),
  'Daun Sehat': PenyakitInfo(
    namaTampil: 'Daun Sehat (Healthy)',
    gejala: [
      'Daun berwarna hijau normal, tidak terdapat bercak, mosaik, keriting, atau nekrosis. Pertumbuhan daun tampak normal.'
    ],
    pengendalian: [
      'Lanjutkan perawatan rutin tanaman. Jaga sanitasi lahan. Serta lakukan pemantauan berkala untuk deteksi dini.',
    ],
  ),
  'Non Daun': PenyakitInfo(
    namaTampil: 'Non Daun',
    gejala: [
      'Objek yang terdeteksi bukan jenis daun tanaman cabai.',
    ],
    pengendalian: [
      'Pastikan kamera diarahkan langsung ke daun cabai. Ambil gambar dengan fokus yang jelas pada daun. Hindari objek lain agar tidak mengganggu proses deteksi.'
    ],
  ),
};