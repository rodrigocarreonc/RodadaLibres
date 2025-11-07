import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};
  List<dynamic> _puntos = [];
  String _filtroActual = "Todos";

  @override
  void initState() {
    super.initState();
    _cargarPuntos();
  }

  Future<void> _cargarPuntos() async {
    final String response =
    await rootBundle.loadString('assets/data/puntos.json');
    final data = await json.decode(response);

    setState(() {
      _puntos = data["puntos"];
      _actualizarMarcadores();
    });
  }

  void _actualizarMarcadores() {
    Set<Marker> nuevosMarcadores = {};

    for (var punto in _puntos) {
      if (_filtroActual == "Todos" || punto["tipo"] == _filtroActual) {
        nuevosMarcadores.add(
          Marker(
            markerId: MarkerId(punto["nombre"]),
            position: LatLng(punto["latitud"], punto["longitud"]),
            infoWindow: InfoWindow(title: punto["nombre"]),
          ),
        );
      }
    }

    setState(() {
      _markers = nuevosMarcadores;
    });
  }

  void _cambiarFiltro(String nuevoFiltro) {
    setState(() {
      _filtroActual = nuevoFiltro;
      _actualizarMarcadores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.blue.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Menú Principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text('Mapa'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('Acerca de'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Versión 1.0.0')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blue),
              title: const Text('Configuración'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Mapa de Ciclistas'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildFiltroButton("Todos"),
                _buildFiltroButton("Estaciones"),
                _buildFiltroButton("Agencias"),
                _buildFiltroButton("Tiendas"),
                _buildFiltroButton("Baños"),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(21.8853, -102.2916), // Aguascalientes
                zoom: 13,
              ),
              markers: _markers,
              onMapCreated: (controller) => _controller = controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroButton(String tipo) {
    final bool activo = _filtroActual == tipo;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: activo ? Colors.blue : Colors.white,
          foregroundColor: activo ? Colors.white : Colors.blue,
          side: const BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => _cambiarFiltro(tipo),
        child: Text(tipo),
      ),
    );
  }
}
