import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import userRouter from "./routes/user.js";
import licenciaRouter from "./routes/licencia.js";

// Para producción, necesitamos manejar CORS
const cors = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    
    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }
    
    next();
};

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para convertir el body a JSON
app.use(express.json());

// Habilitar CORS para todos los orígenes
app.use(cors);

// Middleware para manejar errores
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        error: 'Error interno del servidor',
        message: process.env.NODE_ENV === 'production' ? 'Algo salió mal' : err.message
    });
});

// Montar las rutas de usuario en '/api'
app.use("/api", userRouter);

// Montar las rutas de licencia en '/api/licencias'
app.use("/api/licencias", licenciaRouter);

// Opciones mejoradas para la conexión a MongoDB
const mongoOptions = {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 45000,
};

// Intentar conectar a MongoDB con reintentos para mayor robustez en entornos cloud
const connectWithRetry = () => {
    console.log('Intentando conectar a MongoDB...');
    mongoose.connect(process.env.MONGODB_URI, mongoOptions)
        .then(() => {
            console.log('Conectado a MongoDB exitosamente');
        })
        .catch(err => {
            console.error('Error de conexión a MongoDB:', err);
            console.log('Reintentando en 5 segundos...');
            setTimeout(connectWithRetry, 5000); // Reintentar después de 5 segundos
        });
};

connectWithRetry();

app.get('/', (req, res) => {
    res.send('API Autos funcionando');
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});