const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET All data
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT u.*, k.nama_kategori, d.nama_dusun
       FROM umkm_unggulan u
       LEFT JOIN kategori_umkm k ON u.kategori_id = k.id
       LEFT JOIN dusun d ON u.dusun_id = d.id
       ORDER BY u.id ASC`
    );
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET by Name
router.get('/nama/:nama', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT u.*, k.nama_kategori, d.nama_dusun
       FROM umkm_unggulan u
       LEFT JOIN kategori_umkm k ON u.kategori_id = k.id
       LEFT JOIN dusun d ON u.dusun_id = d.id
       WHERE u.nama_umkm ILIKE $1
       ORDER BY u.id ASC`,
      [`%${req.params.nama}%`]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    }
    res.json({ success: true, data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET by ID
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT u.*, k.nama_kategori, d.nama_dusun,
              dt.jam_operasional, dt.instagram, dt.tautan_gmaps,
              dt.tahun_berdiri, dt.jumlah_karyawan
       FROM umkm_unggulan u
       LEFT JOIN kategori_umkm k ON u.kategori_id = k.id
       LEFT JOIN dusun d ON u.dusun_id = d.id
       LEFT JOIN detail_umkm dt ON dt.umkm_id = u.id
       WHERE u.id = $1`,
      [req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    }
    const produk = await pool.query(
      'SELECT id, nama_produk, harga, deskripsi FROM produk_umkm WHERE umkm_id = $1 ORDER BY id',
      [req.params.id]
    );
    const kegiatan = await pool.query(
      `SELECT kg.id, kg.nama_kegiatan, kg.tanggal, kg.lokasi, p.no_stand
       FROM partisipasi_kegiatan p
       JOIN kegiatan_desa kg ON kg.id = p.kegiatan_id
       WHERE p.umkm_id = $1
       ORDER BY kg.tanggal`,
      [req.params.id]
    );
    res.json({
      success: true,
      data: { ...result.rows[0], produk: produk.rows, kegiatan: kegiatan.rows },
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// POST New Data
router.post('/', async (req, res) => {
  try {
    const { nama_umkm, nama_pemilik, no_whatsapp, alamat, deskripsi_singkat, kategori_id, dusun_id } = req.body;
    if (!nama_umkm || !nama_pemilik || !no_whatsapp || !alamat || !deskripsi_singkat) {
      return res.status(400).json({
        success: false,
        message: 'nama_umkm, nama_pemilik, no_whatsapp, alamat, dan deskripsi_singkat wajib diisi',
      });
    }
    const result = await pool.query(
      `INSERT INTO umkm_unggulan
         (nama_umkm, nama_pemilik, no_whatsapp, alamat, deskripsi_singkat, kategori_id, dusun_id)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [nama_umkm, nama_pemilik, no_whatsapp, alamat, deskripsi_singkat, kategori_id || null, dusun_id || null]
    );
    res.status(201).json({ success: true, message: 'Data berhasil dibuat', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// PUT Data Update
router.put('/:id', async (req, res) => {
  try {
    const { nama_umkm, nama_pemilik, no_whatsapp, alamat, deskripsi_singkat, kategori_id, dusun_id } = req.body;
    if (!nama_umkm || !nama_pemilik || !no_whatsapp || !alamat || !deskripsi_singkat) {
      return res.status(400).json({
        success: false,
        message: 'nama_umkm, nama_pemilik, no_whatsapp, alamat, dan deskripsi_singkat wajib diisi',
      });
    }
    const result = await pool.query(
      `UPDATE umkm_unggulan
       SET nama_umkm=$1, nama_pemilik=$2, no_whatsapp=$3, alamat=$4,
           deskripsi_singkat=$5, kategori_id=$6, dusun_id=$7, updated_at=CURRENT_TIMESTAMP
       WHERE id=$8 RETURNING *`,
      [nama_umkm, nama_pemilik, no_whatsapp, alamat, deskripsi_singkat, kategori_id || null, dusun_id || null, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    }
    res.json({ success: true, message: 'Data berhasil diperbarui', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// DELETE Data
router.delete('/:id', async (req, res) => {
  try {
    const result = await pool.query('DELETE FROM umkm_unggulan WHERE id = $1 RETURNING *', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Data tidak ditemukan' });
    }
    res.json({ success: true, message: 'Data berhasil dihapus', data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;