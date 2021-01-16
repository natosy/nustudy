class Venue {
  String name;

  Venue({this.name});

  static Venue create(String name) {
    return new Venue(name: name);
  }

  String getName() {
    return name;
  }

  @override
  String toString() {
    return "Location: ${this.name}";
  }
}
