import mongoose from 'mongoose';

const licenciaSchema = new mongoose.Schema({
    nombreCompleto: { type: String, required: true },
    numeroLicencia: { type: String, required: true, unique: true },
    gmail: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    confirmacionPassword: { type: String, required: true, validate: {
        validator: function(value) {
            return value === this.password;
        },
        message: 'Las contraseñas no coinciden'
    }}
});

// Middleware para validar que las contraseñas coincidan antes de guardar
licenciaSchema.pre('save', function(next) {
    if (this.password !== this.confirmacionPassword) {
        next(new Error('Las contraseñas no coinciden'));
    } else {
        next();
    }
});

export default mongoose.model('Licencia', licenciaSchema);