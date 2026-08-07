/// User model matching the Fake Store API /users response shape.
class UserModel {
  final int id;
  final String email;
  final String username;
  final String password;
  final NameModel name;
  final AddressModel address;
  final String phone;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      name: json['name'] != null
          ? NameModel.fromJson(json['name'] as Map<String, dynamic>)
          : const NameModel(firstname: '', lastname: ''),
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : AddressModel.empty(),
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'name': name.toJson(),
      'address': address.toJson(),
      'phone': phone,
    };
  }

  /// Convenience getter for display purposes.
  String get fullName => '${name.firstname} ${name.lastname}'.trim();
}

class NameModel {
  final String firstname;
  final String lastname;

  const NameModel({
    required this.firstname,
    required this.lastname,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}

class AddressModel {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeolocationModel geolocation;

  const AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory AddressModel.empty() => AddressModel(
        city: '',
        street: '',
        number: 0,
        zipcode: '',
        geolocation: const GeolocationModel(lat: '', long: ''),
      );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      zipcode: json['zipcode'] as String? ?? '',
      geolocation: json['geolocation'] != null
          ? GeolocationModel.fromJson(
              json['geolocation'] as Map<String, dynamic>)
          : const GeolocationModel(lat: '', long: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      'geolocation': geolocation.toJson(),
    };
  }

  /// Convenience getter for display purposes.
  String get formatted => '$number $street, $city $zipcode';
}

class GeolocationModel {
  final String lat;
  final String long;

  const GeolocationModel({
    required this.lat,
    required this.long,
  });

  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(
      lat: json['lat'] as String? ?? '',
      long: json['long'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
}