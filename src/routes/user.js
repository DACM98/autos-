import express from "express";
import bcrypt from "bcrypt";
import User from "../models/user.js";
import jwt from "jsonwebtoken";

const router = express.Router();

router.post("/users", async (req, res) => {
    try {
        const { nombre, email, password } = req.body;

        // Validar que todos los campos estén presentes
        if (!nombre || !email || !password) {
            return res.status(400).json({ error: "Faltan campos requeridos" });
        }

        // Encriptar la contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        // Crear instancia del modelo
        const user = new User({ nombre, email, password: hashedPassword });

        // Guardar en la base de datos
        await user.save();

        res.status(201).json({ message: "Usuario creado correctamente", user });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Obtener todos los usuarios
router.get('/', async (req, res) => {
    const users = await User.find();
    res.json(users);
});

// Obtener un usuario por ID
router.get('/:id', async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Actualizar usuario
router.put('/:id', async (req, res) => {
    try {
        const { nombre, email, password } = req.body;
        const updateData = { nombre, email };
        if (password) {
            updateData.password = await bcrypt.hash(password, 10);
        }
        const user = await User.findByIdAndUpdate(req.params.id, updateData, { new: true });
        if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
        res.json(user);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Eliminar usuario
router.delete('/:id', async (req, res) => {
    try {
        const user = await User.findByIdAndDelete(req.params.id);
        if (!user) return res.status(404).json({ error: 'Usuario no encontrado' });
        res.json({ message: 'Usuario eliminado' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Inicio de sesión
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        
        // Validar que se proporcionen email y password
        if (!email || !password) {
            return res.status(400).json({ error: "Email y password son requeridos" });
        }
        
        // Buscar usuario por email
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).json({ error: "Credenciales inválidas" });
        }
        
        // Verificar contraseña
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return res.status(401).json({ error: "Credenciales inválidas" });
        }
        
        // Generar token JWT
        const token = jwt.sign(
            { userId: user._id, email: user.email },
            process.env.JWT_SECRET || 'secreto_temporal',
            { expiresIn: '1h' }
        );
        
        res.json({
            message: "Inicio de sesión exitoso",
            token,
            user: {
                id: user._id,
                nombre: user.nombre,
                email: user.email
            }
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

export default router;