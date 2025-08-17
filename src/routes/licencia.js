import express from "express";
import bcrypt from "bcrypt";
import Licencia from "../models/licencia.js";
import jwt from "jsonwebtoken";

const router = express.Router();

// Crear una nueva licencia
router.post("/", async (req, res) => {
    try {
        const { nombreCompleto, numeroLicencia, gmail, password, confirmacionPassword } = req.body;

        // Validar que todos los campos estén presentes
        if (!nombreCompleto || !numeroLicencia || !gmail || !password || !confirmacionPassword) {
            return res.status(400).json({ error: "Faltan campos requeridos" });
        }

        // Validar que las contraseñas coincidan
        if (password !== confirmacionPassword) {
            return res.status(400).json({ error: "Las contraseñas no coinciden" });
        }

        // Encriptar la contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        // Crear instancia del modelo
        const licencia = new Licencia({ 
            nombreCompleto, 
            numeroLicencia, 
            gmail, 
            password: hashedPassword, 
            confirmacionPassword: hashedPassword 
        });

        // Guardar en la base de datos
        await licencia.save();

        res.status(201).json({ message: "Licencia creada correctamente", licencia });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Obtener todas las licencias
router.get('/', async (req, res) => {
    try {
        const licencias = await Licencia.find();
        res.json(licencias);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Obtener una licencia por ID
router.get('/:id', async (req, res) => {
    try {
        const licencia = await Licencia.findById(req.params.id);
        if (!licencia) return res.status(404).json({ error: 'Licencia no encontrada' });
        res.json(licencia);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Actualizar licencia
router.put('/:id', async (req, res) => {
    try {
        const { nombreCompleto, numeroLicencia, gmail, password, confirmacionPassword } = req.body;
        const updateData = { nombreCompleto, numeroLicencia, gmail };
        
        if (password && confirmacionPassword) {
            // Validar que las contraseñas coincidan
            if (password !== confirmacionPassword) {
                return res.status(400).json({ error: "Las contraseñas no coinciden" });
            }
            updateData.password = await bcrypt.hash(password, 10);
            updateData.confirmacionPassword = updateData.password;
        }
        
        const licencia = await Licencia.findByIdAndUpdate(req.params.id, updateData, { new: true });
        if (!licencia) return res.status(404).json({ error: 'Licencia no encontrada' });
        res.json(licencia);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Eliminar licencia
router.delete('/:id', async (req, res) => {
    try {
        const licencia = await Licencia.findByIdAndDelete(req.params.id);
        if (!licencia) return res.status(404).json({ error: 'Licencia no encontrada' });
        res.json({ message: 'Licencia eliminada' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Inicio de sesión con licencia
router.post('/login', async (req, res) => {
    try {
        const { gmail, password } = req.body;
        
        // Validar que se proporcionen gmail y password
        if (!gmail || !password) {
            return res.status(400).json({ error: "Gmail y password son requeridos" });
        }
        
        // Buscar licencia por gmail
        const licencia = await Licencia.findOne({ gmail });
        if (!licencia) {
            return res.status(401).json({ error: "Credenciales inválidas" });
        }
        
        // Verificar contraseña
        const isPasswordValid = await bcrypt.compare(password, licencia.password);
        if (!isPasswordValid) {
            return res.status(401).json({ error: "Credenciales inválidas" });
        }
        
        // Generar token JWT
        const token = jwt.sign(
            { licenciaId: licencia._id, gmail: licencia.gmail },
            process.env.JWT_SECRET || 'secreto_temporal',
            { expiresIn: '1h' }
        );
        
        res.json({
            message: "Inicio de sesión exitoso",
            token,
            licencia: {
                id: licencia._id,
                nombreCompleto: licencia.nombreCompleto,
                numeroLicencia: licencia.numeroLicencia,
                gmail: licencia.gmail
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

export default router;