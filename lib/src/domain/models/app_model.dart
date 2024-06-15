// To parse this JSON data, do
//
//     final appModel = appModelFromMap(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

AppModel appModelFromMap(String str) => AppModel.fromMap(json.decode(str));

String appModelToMap(AppModel data) => json.encode(data.toMap());

class AppModel extends Equatable {
  final bool isLightTheme;
  final int currentTab;
  final bool loggedIn;

  const AppModel({
    required this.isLightTheme,
    required this.currentTab,
    required this.loggedIn,
  });

  AppModel copyWith({
    bool? isLightTheme,
    int? currentTab,
    bool? loggedIn,
  }) =>
      AppModel(
        isLightTheme: isLightTheme ?? this.isLightTheme,
        currentTab: currentTab ?? this.currentTab,
        loggedIn: loggedIn ?? this.loggedIn,
      );
  const AppModel.initial()
      : this(currentTab: 0, isLightTheme: true, loggedIn: false);
  factory AppModel.fromMap(Map<String, dynamic> json) => AppModel(
        isLightTheme: json["isLightTheme"],
        currentTab: json["currentTab"],
        loggedIn: json["loggedIn"],
      );

  Map<String, dynamic> toMap() => {
        "isLightTheme": isLightTheme,
        "currentTab": currentTab,
        "loggedIn": loggedIn,
      };

  @override
  List<Object?> get props => [isLightTheme, currentTab, loggedIn];
}
