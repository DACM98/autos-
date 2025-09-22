import 'package:flutter/material.dart';

// Suponiendo que tienes una clase MenuDrawerPerfil ya implementada
import 'menu_drawer_perfil.dart';
import 'calculadorapage.dart';
import 'loginpage.dart';
import 'preferences.dart';
import 'controllers/autos_controller.dart';
import 'detalleVehiculo.dart';

// Widget principal con navegación inferior y menú lateral
class AlquilerAutoScreen extends StatefulWidget {
  final int? clienteId; // Agregamos clienteId al constructor
  
  const AlquilerAutoScreen({super.key, this.clienteId});

  @override
  _AlquilerAutoScreenState createState() => _AlquilerAutoScreenState();
}

class _AlquilerAutoScreenState extends State<AlquilerAutoScreen> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada
  String _busqueda = '';
  
  // Variables para manejar los autos desde la API
  List<Map<String, dynamic>> _listaDeAutos = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _clienteId; // Variable para almacenar el ID del cliente

  @override
  void initState() {
    super.initState();
    _inicializarClienteId();
    _cargarAutos();
  }

  // Método para inicializar el clienteId
  Future<void> _inicializarClienteId() async {
    // Si no se pasó por constructor, intentar obtenerlo de SharedPreferences
    if (widget.clienteId != null) {
      _clienteId = widget.clienteId;
    } else {
      _clienteId = await Preferences.getClienteId();
    }
    
    // Debug: imprimir el clienteId
    print('Cliente ID inicializado: $_clienteId');
  }

  // Método para cargar autos desde la API
  Future<void> _cargarAutos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final autos = await AutosController.obtenerAutosDisponibles();
      setState(() {
        _listaDeAutos = autos;
        _isLoading = false;
      });
      
      // Debug: imprimir cantidad de autos cargados
      print('Autos cargados: ${_listaDeAutos.length}');
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar autos: ${e.toString()}';
        _isLoading = false;
      });
      
      // Debug: imprimir error
      print('Error al cargar autos: $e');
    }
  }

  // Pestaña de bienvenida con imagen de fondo y accesos rápidos
  Widget _buildInicio() {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.network(
            'https://fastly.picsum.photos/id/26/4209/2769.jpg?hmac=vcInmowFvPCyKGtV7Vfh7zWcA_Z0kStrPDW3ppP0iGI',
            fit: BoxFit.cover,
          ),
        ),
        // Contenido superpuesto
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Título principal
                const Text(
                  'Bienvenido a\nAlquiler de Autos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                // Subtítulo
                const Text(
                  'Encuentra el vehículo perfecto\npara tu viaje',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.3,
                  ),
                ),
                const Spacer(),
                // Botones de acceso rápido
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Botón para ir a alquiler
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 99, 38),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Ver Vehículos Disponibles',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Botón para ir a calculadora
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => _navigateTo(context, CalculadoraPage()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Calculadora de Precios',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Pestaña de alquiler: muestra la lista de vehículos disponibles
  Widget _buildAlquiler() {
    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _busqueda = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Buscar vehículos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        
        // Contenido de la lista
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 99, 38),
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _cargarAutos,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : _listaDeAutos.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay vehículos disponibles',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildListaAutos(),
        ),
      ],
    );
  }

  // Widget para construir la lista de autos
  Widget _buildListaAutos() {
    // Filtrar autos según la búsqueda
    final autosFiltrados = _listaDeAutos.where((auto) {
      final busqueda = _busqueda.toLowerCase();
      return auto['marca'].toString().toLowerCase().contains(busqueda) ||
             auto['modelo'].toString().toLowerCase().contains(busqueda) ||
             auto['placa'].toString().toLowerCase().contains(busqueda);
    }).toList();

    return RefreshIndicator(
      onRefresh: _cargarAutos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: autosFiltrados.length,
        itemBuilder: (context, index) {
          final auto = autosFiltrados[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () => _navegarADetalle(auto),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Imagen del vehículo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: auto['imagen'] != null && auto['imagen'].isNotEmpty
                          ? Image.network(
                              auto['imagen'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.directions_car,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.directions_car,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Información del vehículo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${auto['marca']} ${auto['modelo']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Año: ${auto['anio']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Placa: ${auto['placa']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 16,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '\$${auto['valorAlquiler']}/día',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Estado de disponibilidad
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: auto['disponible'] ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        auto['disponible'] ? 'Disponible' : 'No Disponible',
                        style: TextStyle(
                          fontSize: 12,
                          color: auto['disponible'] ? Colors.green[700] : Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Método para navegar al detalle del vehículo
  Future<void> _navegarADetalle(Map<String, dynamic> auto) async {
    // Asegurar que tenemos el clienteId
    _clienteId ??= await Preferences.getClienteId();
    
    // Debug: imprimir datos de navegación
    print('Navegando al detalle del vehículo:');
    print('Auto ID: ${auto['id']}');
    print('Cliente ID: $_clienteId');
    print('Marca: ${auto['marca']}');
    print('Modelo: ${auto['modelo']}');
    
    if (!mounted) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleVehiculoScreen(
          auto: auto,
          clienteId: _clienteId ?? 0,
        ),
      ),
    );
  }

  // Pestaña de usuario: muestra el perfil y opciones
  Widget _buildUsuario() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Foto de perfil
          const CircleAvatar(
            radius: 48,
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
          ),
          const SizedBox(height: 16),
          // Nombre de usuario
          const Text(
            'Nombre de Usuario',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Correo electrónico
          const Text(
            'correo@ejemplo.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // Número de licencia
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.badge, color: Colors.blueAccent),
              title: Text('Número de licencia'),
              subtitle: Text('123456789'),
            ),
          ),
          // Cambiar contraseña
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.orange),
              title: Text('Cambiar contraseña'),
              onTap: () {},
            ),
          ),
          // Revisar alquileres
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.search, color: Colors.deepOrange),
              title: Text('Revisar Alquileres'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          // Botón para salir de la app (cerrar sesión)
          ElevatedButton.icon(
            onPressed: () async {
              await Preferences.clearUserData();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              }
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Salir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 203, 255, 82),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navegación a otras pantallas
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Lista de pantallas para la navegación inferior
  List<Widget> _screens() => [
    _buildInicio(),
    _buildAlquiler(),
    _buildUsuario(),
  ];

  @override
  Widget build(BuildContext context) {
    // Títulos para el AppBar según la pestaña seleccionada
    final appBarTitles = ['Bienvenido', 'Alquiler de Autos', 'Perfil de Usuario'];
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_selectedIndex]),
        backgroundColor: const Color.fromARGB(255, 255, 68, 183),
      ),
      drawer: MenuDrawerPerfil(), // Menú lateral
      body: _screens()[_selectedIndex], // Contenido según la pestaña
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 68, 255, 152),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Alquiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuario',
          ),
        ],
      ),
    );
  }
}