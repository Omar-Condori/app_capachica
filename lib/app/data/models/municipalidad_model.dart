class Municipalidad {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagenUrl;
  final String? ubicacion;
  final String? telefono;
  final String? email;
  final String? website;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Municipalidad({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagenUrl,
    this.ubicacion,
    this.telefono,
    this.email,
    this.website,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Municipalidad.fromJson(Map<String, dynamic> json) {
    return Municipalidad(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      imagenUrl: json['imagen_url'] ?? json['imagenUrl'],
      ubicacion: json['ubicacion'],
      telefono: json['telefono'],
      email: json['email'],
      website: json['website'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
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
      'ubicacion': ubicacion,
      'telefono': telefono,
      'email': email,
      'website': website,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 