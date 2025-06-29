class Emprendedor {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagenUrl;
  final String? telefono;
  final String? email;
  final String? ubicacion;
  final String? website;
  final String? categoria;
  final double? rating;
  final int? numResenas;
  final bool isActivo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Emprendedor({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagenUrl,
    this.telefono,
    this.email,
    this.ubicacion,
    this.website,
    this.categoria,
    this.rating,
    this.numResenas,
    required this.isActivo,
    this.createdAt,
    this.updatedAt,
  });

  factory Emprendedor.fromJson(Map<String, dynamic> json) {
    return Emprendedor(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      imagenUrl: json['imagen_url'] ?? json['imagenUrl'],
      telefono: json['telefono'],
      email: json['email'],
      ubicacion: json['ubicacion'],
      website: json['website'],
      categoria: json['categoria'],
      rating: json['rating']?.toDouble(),
      numResenas: json['num_resenas'] ?? json['numResenas'],
      isActivo: json['is_activo'] ?? json['isActivo'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen_url': imagenUrl,
      'telefono': telefono,
      'email': email,
      'ubicacion': ubicacion,
      'website': website,
      'categoria': categoria,
      'rating': rating,
      'num_resenas': numResenas,
      'is_activo': isActivo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 