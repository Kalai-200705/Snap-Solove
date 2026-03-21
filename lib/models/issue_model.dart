class Issue {
  String title;
  String description;
  String status;
  double lat;
  double lng;
  String? imagePath;

  Issue({
    required this.title,
    required this.description,
    required this.status,
    required this.lat,
    required this.lng,
    this.imagePath,
  });
}