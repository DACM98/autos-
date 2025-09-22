# Backend para Alquiler de Autos

## Configuración del Backend

### 1. Instalación de Dependencias
```bash
npm install
```

### 2. Configuración de la Base de Datos
Asegúrate de tener configurado tu archivo de configuración de base de datos en `config/config.json`

### 3. Ejecución de Migraciones

#### Revertir todas las migraciones:
```bash
npx sequelize-cli db:migrate:undo:all
```

#### Ejecutar migraciones:
```bash
npx sequelize-cli db:migrate
```

### 4. Estructura de la API

#### Endpoints de Clientes:
- `POST /api/clientes` - Registrar nuevo cliente
- `POST /api/clientes/login` - Login de cliente

#### Endpoints de Vehículos:
- `GET /api/disponibles` - Obtener vehículos disponibles
- `GET /api/autos/:id` - Obtener vehículo por ID

#### Endpoints de Alquileres:
- `POST /api/alquileres` - Registrar nuevo alquiler
- `GET /api/alquileres/cliente/:clienteId` - Obtener alquileres de un cliente
- `PUT /api/alquileres/:id/cancelar` - Cancelar un alquiler

### 5. Campos de la Tabla Vehículos
- `id` - ID único del vehículo
- `marca` - Marca del vehículo
- `modelo` - Modelo del vehículo
- `anio` - Año del vehículo
- `placa` - Placa del vehículo
- `imagen` - URL de la imagen del vehículo
- `valorAlquiler` - Valor del alquiler por día
- `disponible` - Estado de disponibilidad
- `descripcion` - Descripción del vehículo

### 6. Campos de la Tabla Alquileres
- `id` - ID único del alquiler
- `clienteId` - ID del cliente que alquila
- `autoId` - ID del vehículo alquilado
- `fechaInicio` - Fecha de inicio del alquiler
- `fechaFin` - Fecha de fin del alquiler
- `valorTotal` - Valor total del alquiler
- `estado` - Estado del alquiler (activo, cancelado, finalizado)
- `createdAt` - Fecha de creación
- `updatedAt` - Fecha de última actualización

### 7. Ejemplo de Registro de Vehículo en Thunder Client
```json
{
  "marca": "Toyota",
  "modelo": "Corolla",
  "anio": 2022,
  "placa": "ABC123",
  "imagen": "https://ejemplo.com/imagen.jpg",
  "valorAlquiler": 45.00,
  "disponible": true,
  "descripcion": "Vehículo compacto ideal para ciudad"
}
```

### 8. Ejemplo de Registro de Alquiler en Thunder Client
```json
{
  "clienteId": 1,
  "autoId": 1,
  "fechaInicio": "2024-01-15T00:00:00.000Z",
  "fechaFin": "2024-01-16T00:00:00.000Z",
  "valorTotal": 45.00
}
```

### 9. Iniciar el Servidor
```bash
npm start
# o
node server.js
```

El servidor estará disponible en `http://localhost:3000`

### 10. Estructura de Respuestas

#### Respuesta Exitosa:
```json
{
  "success": true,
  "message": "Operación realizada exitosamente",
  "data": { ... }
}
```

#### Respuesta de Error:
```json
{
  "success": false,
  "message": "Descripción del error",
  "error": "Detalles adicionales del error"
}
```

### 11. Flujo de Alquiler
1. Cliente hace login y se obtiene su ID
2. Cliente navega por la lista de vehículos disponibles
3. Cliente selecciona un vehículo y va al detalle
4. Cliente confirma el alquiler
5. Se registra el alquiler en la base de datos
6. El vehículo se marca como no disponible
7. Se muestra confirmación al cliente
