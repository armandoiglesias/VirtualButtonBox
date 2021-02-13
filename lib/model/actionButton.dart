// {
//   id : 1,
//   texto : "Es una cadena",
//   isToggle : bool,
//   filePath : "",
//   index : 1,
// }

// To parse this JSON data, do
//
//     final actionButton = actionButtonFromJson(jsonString);

import 'dart:convert';

ActionButtonModel actionButtonModelFromMap(String str) =>
    ActionButtonModel.fromMap(json.decode(str));

String actionButtonModelToMap(ActionButtonModel data) =>
    json.encode(data.toMap());

class ActionButtonModel {
  ActionButtonModel({
    this.id,
    this.texto,
    this.isToggle,
    this.filePath,
    this.indice,
  });

  int id;
  String texto;
  int isToggle;
  String filePath;
  int indice;

  factory ActionButtonModel.fromMap(Map<String, dynamic> json) =>
      ActionButtonModel(
        id: json["id"],
        texto: json["texto"],
        isToggle: json["isToggle"],
        filePath: json["filePath"],
        indice: json["indice"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "texto": texto,
        "isToggle": isToggle,
        "filePath": filePath,
        "indice": indice,
      };
}
