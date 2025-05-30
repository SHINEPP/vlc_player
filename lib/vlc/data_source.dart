enum DataSourceType {
  /// The video was included in the app's asset files.
  asset,

  /// The video was downloaded from the internet.
  network,

  /// The video was loaded off of the local filesystem.
  file,

  /// android content uri
  contentUri,
}

class DataSource {
  final DataSourceType type;
  final String value;

  DataSource({required this.type, required this.value});
}
