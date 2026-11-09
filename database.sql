CREATE TABLE Kategori_UMKM (
  id SERIAL PRIMARY KEY,
  nama_kategori VARCHAR (100) NOT NULL UNIQUE,
  deskripsi TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE Dusun (
  id SERIAL PRIMARY KEY,
  nama_dusun VARCHAR (100) NOT NULL,
  nama_kepala_dusun VARCHAR (100),
  jumlah_rt INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE UMKM_Unggulan (
    id SERIAL PRIMARY KEY,
    nama_umkm VARCHAR (100) NOT NULL,
    nama_pemilik VARCHAR (100) NOT NULL,
    no_whatsapp VARCHAR (20) NOT NULL,
    alamat TEXT NOT NULL,
    deskripsi_singkat TEXT NOT NULL,
    kategori_id INT REFERENCES Kategori_UMKM (id) ON DELETE SET NULL,
    dusun_id INT REFERENCES Dusun (id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Detail_UMKM (
  id SERIAL PRIMARY KEY,
  umkm_id INT NOT NULL UNIQUE REFERENCES UMKM_Unggulan (id) ON DELETE SET NULL,
  jam_operasional VARCHAR (100),
  instagram VARCHAR (100),
  tautan_gmaps TEXT,
  tahun_berdiri INT,
  jumlah_karyawan INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE Produk_UMKM (
   id SERIAL PRIMARY KEY,
    umkm_id INT NOT NULL REFERENCES UMKM_Unggulan (id) ON DELETE CASCADE,
    nama_produk VARCHAR (100) NOT NULL,
    harga NUMERIC (12,2) NOT NULL,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE Kegiatan_Desa(
  id SERIAL PRIMARY KEY,
  nama_kegiatan VARCHAR (150) NOT NULL,
  tanggal DATE NOT NULL,
  lokasi VARCHAR NOT NULL,
  deskripsi TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)

CREATE TABLE Partisipasi_Kegiatan (
  umkm_id INT NOT NULL REFERENCES UMKM_Unggulan (id) ON DELETE CASCADE,
  kegiatan_id INT NOT NULL REFERENCES Kegiatan_Desa (id) ON DELETE CASCADE,
  no_stand VARCHAR (20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (umkm_id, kegiatan_id)
)

INSERT INTO Kategori_UMKM (nama_kategori, deskripsi) VALUES
('Kuliner', 'Usaha makanan dan minuman'),
('Perdagangan', 'Usaha jual beli kebutuhan sehari-hari'),
('Kerajinan', 'Usaha produk kerajinan tangan');

INSERT INTO Dusun (nama_dusun, nama_kepala_dusun, jumlah_rt) VALUES
('Dusun Tambak Boyo', 'Pak Kariman', 4),
('Dusun Tikung', 'Pak Ambarita', 3),
('Dusun Tambakrigadung', 'Pak Mulyono', 3);

INSERT INTO UMKM_Unggulan (nama_umkm, nama_pemilik, no_whatsapp, alamat, deskripsi_singkat, kategori_id, dusun_id) VALUES
('Warung Madura 25 Jam', 'Budiono Siregar', '08112233', 'Jl. Raya Tambak Boyo, Tikung, Tambakboyo, Tambakrigadung, Kec. Lamongan, Kabupaten Lamongan, Jawa Timur 62281', 'Toko sembako yang menyediakan berbagai kebutuhan pokok dengan harga terjangkau.', 2, 1),
('Bakso Mr Amba', 'Ramba Nugraha', '08123456', 'Jl. Raya Tambak Boyo, Tikung, Tambakboyo, Tambakrigadung, Kec. Lamongan, Kabupaten Lamongan, Jawa Timur 62281', 'Bakso spesial yang tidak ada tandingannya (Valentino Rossi pernah kesini).', 1, 2),
('Kerajinan Tak Rajin', 'Marwoto Karmin', '0819887766', 'Jl. Raya Tambak Boyo, Tikung, Tambakboyo, Tambakrigadung, Kec. Lamongan, Kabupaten Lamongan, Jawa Timur 62281', 'UMKM yang memproduksi kerajinan tangan unik dan keren abis pokoknya.', 3, 3);

INSERT INTO Detail_UMKM (umkm_id, jam_operasional, instagram, tautan_gmaps, tahun_berdiri, jumlah_karyawan) VALUES
(1, '00.00-25.99', '@wrm_25jamlohya', 'https://maps.google.com/', 1945, 3),
(2, '07.00-07.05', '@ambakso', 'https://maps.google.com/', 2022, 4),
(3, '08.00-16.00', '@kerajinan.takrajin', 'https://maps.google.com/', 2026, 2);

INSERT INTO Produk_UMKM (umkm_id, nama_produk, harga, deskripsi) VALUES
(1, 'Beras 5 Kg', 68000, 'Beras Premium Kemasan 5 Kg'),
(1, 'Minyak Goreng 1 L', 17000, 'Minyak Goreng Kemasan 1 Liter'),
(2, 'Bakso Tanpa Tepung', 15000, 'Bakso Premium Full Ndaging Loh Ya'),
(2, 'Es Teh Anget', 4000, 'Sewajarnya Es Teh di Luar Sana'),
(3, 'Tas Anyaman Pandan', 85000, 'Tas Anyaman dari Pandan Lokal'),
(3, 'Tempat Tisu Rotan', 45000, 'Tempat Tisu dari Rotan');

INSERT INTO Kegiatan_Desa (nama_kegiatan, tanggal, lokasi, deskripsi) VALUES
('Bazar UMKM Desa', '2026-12-20', 'Balai Desa Tambakrigadung', 'Bazar tahunan untuk memperkenalkan produk UMKM warga.'),
('Pameran Produk Lokal', '2027-01-15', 'Lapangan Desa Tambakrigadung', 'Pameran produk unggulan desa untuk umum.');

INSERT INTO Partisipasi_Kegiatan (umkm_id, kegiatan_id, no_stand) VALUES
(1, 1, 'A1'),
(2, 1, 'A2'),
(3, 1, 'B1'),
(2, 2, 'C1'),
(3, 2, 'C2');

SELECT u.nama_umkm, k.nama_kategori, d.nama_dusun
FROM UMKM_Unggulan u
LEFT JOIN Kategori_UMKM k ON u.kategori_id = k.id
LEFT JOIN Dusun d ON u.dusun_id = d.id;