class Placeholder {
  String name;
  String type;
  String? format;
  String? example;

  Placeholder(this.name, this.type, {this.format, this.example});
}

class Token {
  String name;
  String? description;
  List<Placeholder> placeholders;
  Map<String, String> values = {};

  Token({this.name = '', this.description, this.placeholders = const []});

  addPlaceHolder(Placeholder placeholder) {
    placeholders.add(placeholder);
  }

  setLocaleString(String locale, String value) {
    values[locale] = value;
  }

  @override
  String toString() {
    return 'Token{name: $name, description: $description}';
  }
}
