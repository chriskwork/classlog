class User {
  final int id;
  final String email;
  final String nombre;
  final String apellidos;
  final String? telefono;
  final String? avatarUrl;
  final String? asignatura;
  final String? descripcion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellidos,
    this.telefono,
    this.avatarUrl,
    this.asignatura,
    this.descripcion,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$nombre $apellidos';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      telefono: json['telefono'],
      avatarUrl: json['avatar_url'],
      asignatura: json['asignatura'],
      descripcion: json['descripcion'],
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
      'email': email,
      'nombre': nombre,
      'apellidos': apellidos,
      'telefono': telefono,
      'avatar_url': avatarUrl,
      'asignatura': asignatura,
      'descripcion': descripcion,
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? nombre,
    String? apellidos,
    String? telefono,
    String? avatarUrl,
    String? asignatura,
    String? descripcion,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      telefono: telefono ?? this.telefono,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      asignatura: asignatura ?? this.asignatura,
      descripcion: descripcion ?? this.descripcion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
