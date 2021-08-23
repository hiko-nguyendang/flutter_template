class StringHelper {
  static String stringToAscii(String optionName) {
    List<String> specialCharacters = [' ', '-', '%', '.'];
    for (int i = 0; i < optionName.length; i++) {
      if (specialCharacters.contains(optionName[i])) {
        optionName = optionName.replaceAll(
            optionName[i], optionName.codeUnitAt(i).toString());
      }
    }
    return optionName;
  }
}
