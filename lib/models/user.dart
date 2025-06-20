class User {
  final int id;
  final String email;
  final String name;
  final String identification;
  final String phone;
  final bool naturalPerson;
  final String gender;
  final String address;
  final String role;
  final bool active;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.identification,
    required this.phone,
    required this.gender,
    required this.address,
    required this.naturalPerson,
    required this.role,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'identification': identification,
        'phone': phone,
        'gender': gender,
        'address': address,
        'naturalPerson': naturalPerson,
        'role': role,
        'active': active,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        identification: json['identification'],
        phone: json['phone'],
        gender: json['gender'],
        address: json['address'],
        naturalPerson: json['naturalPerson'],
        role: json['role'],
        active: json['active'],
      );
}
