class AssetFinder {
  static icon(String name, {String? type = 'svg'}) {
    return 'assets/icons/$name.$type';
  }

  static image(String name, {String? type = 'png'}) {
    return 'assets/images/$name.$type';
  }

  static audio(String name, {String? type = 'mp3'}) {
    return 'assets/audios/$name.$type';
  }
}
