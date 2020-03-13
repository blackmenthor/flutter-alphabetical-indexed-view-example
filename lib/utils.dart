List<String> getAlphabetsFromStringList(List<String> originalList) {
  List<String> alphabets = [];

  for (String item in originalList)
    if (!alphabets.contains(item[0]))
      alphabets.add(item[0]);

  alphabets.sort((a,b) => a.compareTo(b));

  return alphabets;
}