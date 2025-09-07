class AppSettings {
  int? id;
  DateTime? firstLaunch;

  AppSettings({this.id, this.firstLaunch});

  // Convertir a Map para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstLaunch': firstLaunch?.millisecondsSinceEpoch,
    };
  }

  // Crear objeto desde Map de SQLite
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'],
      firstLaunch: map['firstLaunch'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['firstLaunch'])
          : null,
    );
  }
}
