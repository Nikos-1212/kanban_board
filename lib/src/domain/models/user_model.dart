// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? limit;
  String? message;
  int? offset;
  bool? success;
  int? totalUsers;
  List<User>? users;

  UserModel({
    this.limit,
    this.message,
    this.offset,
    this.success,
    this.totalUsers,
    this.users,
  });

  UserModel copyWith({
    int? limit,
    String? message,
    int? offset,
    bool? success,
    int? totalUsers,
    List<User>? users,
  }) =>
      UserModel(
        limit: limit ?? this.limit,
        message: message ?? this.message,
        offset: offset ?? this.offset,
        success: success ?? this.success,
        totalUsers: totalUsers ?? this.totalUsers,
        users: users ?? this.users,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        limit: json["limit"],
        message: json["message"],
        offset: json["offset"],
        success: json["success"],
        totalUsers: json["total_users"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "message": message,
        "offset": offset,
        "success": success,
        "total_users": totalUsers,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  int? id;
  Gender? gender;
  DateTime? dateOfBirth;
  String? job;
  String? city;
  String? zipcode;
  double? latitude;
  String? profilePicture;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? street;
  String? state;
  String? country;
  double? longitude;

  User({
    this.id,
    this.gender,
    this.dateOfBirth,
    this.job,
    this.city,
    this.zipcode,
    this.latitude,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.street,
    this.state,
    this.country,
    this.longitude,
  });

  User copyWith({
    int? id,
    Gender? gender,
    DateTime? dateOfBirth,
    String? job,
    String? city,
    String? zipcode,
    double? latitude,
    String? profilePicture,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? street,
    String? state,
    String? country,
    double? longitude,
  }) =>
      User(
        id: id ?? this.id,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        job: job ?? this.job,
        city: city ?? this.city,
        zipcode: zipcode ?? this.zipcode,
        latitude: latitude ?? this.latitude,
        profilePicture: profilePicture ?? this.profilePicture,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        street: street ?? this.street,
        state: state ?? this.state,
        country: country ?? this.country,
        longitude: longitude ?? this.longitude,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        gender: genderValues.map[json["gender"]]!,
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.parse(json["date_of_birth"]),
        job: json["job"],
        city: json["city"],
        zipcode: json["zipcode"],
        latitude: json["latitude"]?.toDouble(),
        profilePicture: json["profile_picture"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        street: json["street"],
        state: json["state"],
        country: json["country"],
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gender": genderValues.reverse[gender],
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "job": job,
        "city": city,
        "zipcode": zipcode,
        "latitude": latitude,
        "profile_picture": profilePicture,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "street": street,
        "state": state,
        "country": country,
        "longitude": longitude,
      };
}

enum Gender { FEMALE, MALE }

final genderValues = EnumValues({"female": Gender.FEMALE, "male": Gender.MALE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
