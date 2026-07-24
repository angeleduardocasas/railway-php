const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Configuración de vistas
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static('public'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Configuración de la base de datos
const dbConfig = {
    host: process.env.MYSQLHOST || 'mysql.railway.internal',
    port: process.env.MYSQLPORT || 3306,
    database: process.env.MYSQLDATABASE || 'railway',
    user: process.env.MYSQLUSER || 'root',
    password: process.env.MYSQLPASSWORD || 'HxEoMLvMKeqgZaESZjviysfmIUNxgceF',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
};

console.log('📊 Configuración de BD:');
console.log(`Host: ${dbConfig.host}`);
console.log(`Base de datos: ${dbConfig.database}`);
console.log(`Usuario: ${dbConfig.user}`);
console.log(`Clave: ${dbConfig.password}`);
console.log(`host: ${dbConfig.host}`);

// Crear pool de conexiones
const pool = mysql.createPool(dbConfig);

// Función para probar la conexión
async function testConnection() {
    try {
        const connection = await pool.getConnection();
        console.log('✅ Conectado a MySQL correctamente');
        connection.release();
        return true;
    } catch (error) {
        console.error('❌ Error de conexión a MySQL:', error.message);
        return false;
    }
}

// Ruta principal - Mostrar todas las personas
app.get('/', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM personas ORDER BY id DESC');
        
        res.render('index', {
            personas: rows,
            total: rows.length,
            dbConfig: {
                host: dbConfig.host,
                database: dbConfig.database
            }
        });
    } catch (error) {
        console.error('Error al obtener personas:', error);
        res.status(500).render('error', {
            message: 'Error al obtener los datos',
            error: error.message
        });
    }
});

// Ruta para agregar una nueva persona
app.post('/personas', async (req, res) => {
    const { nombre, edad } = req.body;
    
    if (!nombre || !edad) {
        return res.status(400).json({ error: 'Nombre y edad son requeridos' });
    }
    
    try {
        const [result] = await pool.query(
            'INSERT INTO personas (nombre, edad) VALUES (?, ?)',
            [nombre, parseInt(edad)]
        );
        
        res.redirect('/');
    } catch (error) {
        console.error('Error al agregar persona:', error);
        res.status(500).json({ error: 'Error al agregar la persona' });
    }
});

// Ruta para eliminar una persona
app.delete('/personas/:id', async (req, res) => {
    const { id } = req.params;
    
    try {
        await pool.query('DELETE FROM personas WHERE id = ?', [id]);
        res.json({ success: true });
    } catch (error) {
        console.error('Error al eliminar persona:', error);
        res.status(500).json({ error: 'Error al eliminar la persona' });
    }
});

// Ruta para actualizar una persona
app.put('/personas/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, edad } = req.body;
    
    try {
        await pool.query(
            'UPDATE personas SET nombre = ?, edad = ? WHERE id = ?',
            [nombre, parseInt(edad), id]
        );
        res.json({ success: true });
    } catch (error) {
        console.error('Error al actualizar persona:', error);
        res.status(500).json({ error: 'Error al actualizar la persona' });
    }
});

// Ruta para obtener una persona por ID (API)
app.get('/api/personas/:id', async (req, res) => {
    const { id } = req.params;
    
    try {
        const [rows] = await pool.query('SELECT * FROM personas WHERE id = ?', [id]);
        
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Persona no encontrada' });
        }
        
        res.json(rows[0]);
    } catch (error) {
        console.error('Error al obtener persona:', error);
        res.status(500).json({ error: 'Error al obtener la persona' });
    }
});

// Ruta de API para todas las personas
app.get('/api/personas', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM personas ORDER BY id DESC');
        res.json(rows);
    } catch (error) {
        console.error('Error al obtener personas:', error);
        res.status(500).json({ error: 'Error al obtener los datos' });
    }
});

// Ruta de estado/health check
app.get('/health', async (req, res) => {
    const connected = await testConnection();
    res.json({
        status: 'OK',
        timestamp: new Date().toISOString(),
        database: connected ? 'connected' : 'disconnected',
        uptime: process.uptime()
    });
});

// Manejo de errores 404
app.use((req, res) => {
    res.status(404).render('error', {
        message: 'Página no encontrada',
        error: '404 - Not Found'
    });
});

// Iniciar servidor
app.listen(PORT, async () => {
    console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
    console.log(`📊 Estado de la BD: ${await testConnection() ? '✅ Conectada' : '❌ Desconectada'}`);
});