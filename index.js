require('dotenv').config();
const express = require('express');
const umkmRoutes = require('./routes/umkm');

const app = express();
app.use(express.json());

app.get('/', (req, res) => res.send('API UMKM Unggulan Berhasil'))
app.use('/api/umkm', umkmRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Server berjalan di http://localhost:3000'));