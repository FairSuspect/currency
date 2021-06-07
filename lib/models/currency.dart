class Currency {
  String? id;
  String? numCode;
  String? charCode;
  int? nominal;
  String? name;
  double? value;
  double? previous;

  Currency(
      {this.charCode,
      this.id,
      this.name,
      this.nominal,
      this.numCode,
      this.previous,
      this.value});

  static Currency? fromJson(Map<String, dynamic>? json) => json == null
      ? null
      : Currency(
          charCode: json[r'CharCode'],
          id: json[r'ID'],
          numCode: json[r'NumCode'],
          nominal: json[r'Nominal'],
          name: json[r'Name'],
          value: json[r'Value'],
          previous: json[r'Previous'],
        );

  static List<Currency?>? listFromJson(
    List<dynamic>? json, {
    bool? emptyIsNull,
    bool? growable,
  }) =>
      json == null || json.isEmpty
          ? true == emptyIsNull
              ? null
              : <Currency>[]
          : json
              .map((v) => Currency.fromJson(v))
              .toList(growable: true == growable);
}
