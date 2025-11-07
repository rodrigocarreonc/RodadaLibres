class Punto {
  final String nombre;
  final String tipo;
  final double lat;
  final double lng;

  Punto({
    required this.nombre,
    required this.tipo,
    required this.lat,
    required this.lng,
  });

  factory Punto.fromJson(Map<String, dynamic> json) => Punto(
    nombre: json['nombre'],
    tipo: json['tipo'],
    lat: json['lat'],
    lng: json['lng'],
  );
}
