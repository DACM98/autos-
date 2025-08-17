# Backend Mercado Libre

API RESTful para gestión de usuarios y licencias.

## Requisitos

- Node.js 14.x o superior
- MongoDB Atlas

## Instalación

```bash
# Clonar el repositorio
git clone <url-del-repositorio>
cd backenmercadolibre

# Instalar dependencias
npm install
```

## Variables de entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

```
MONGODB_URI=tu_uri_de_mongodb_atlas
PORT=3000
JWT_SECRET=tu_clave_secreta_para_jwt
```

## Ejecución

```bash
# Modo desarrollo
npm run dev

# Modo producción
npm start
```

## Despliegue en Render

1. Crea una cuenta en [Render](https://render.com/)
2. Conecta tu repositorio de GitHub
3. Crea un nuevo Web Service
4. Configura las siguientes opciones:
   - **Build Command**: `npm install`
   - **Start Command**: `node index.js`
5. Añade las variables de entorno en la sección "Environment Variables":
   - `NODE_ENV`: production
   - `PORT`: 3000
   - `MONGODB_URI`: tu_uri_de_mongodb_atlas
   - `JWT_SECRET`: tu_clave_secreta_para_jwt
**Nota**: Se ha creado un archivo `index.js` en la raíz del proyecto que importa el archivo principal `src/index.js`. Esto es necesario para el correcto despliegue en Render.

## Endpoints API

### Usuarios

- `POST /api/users`: Crear usuario
- `GET /api`: Obtener todos los usuarios
- `GET /api/:id`: Obtener usuario por ID
- `PUT /api/:id`: Actualizar usuario
- `DELETE /api/:id`: Eliminar usuario
- `POST /api/login`: Iniciar sesión

### Licencias

- `POST /api/licencias`: Crear licencia
- `GET /api/licencias`: Obtener todas las licencias
- `GET /api/licencias/:id`: Obtener licencia por ID
- `PUT /api/licencias/:id`: Actualizar licencia
- `DELETE /api/licencias/:id`: Eliminar licencia
- `POST /api/licencias/login`: Iniciar sesión con licencia