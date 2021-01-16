class Module {
  String moduleCode;
  String moduleTitle;

  Module({this.moduleCode, this.moduleTitle});

  static Module create(String moduleCode, String moduleTitle) {
    Module mod = Module(moduleCode: moduleCode, moduleTitle: moduleTitle);
    return mod;
  }

  @override
  String toString() {
    return "Module Code: ${this.moduleCode}\nTitle: ${this.moduleTitle}";
  }
}
