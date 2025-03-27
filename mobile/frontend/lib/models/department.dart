class Department {
  final String id;
  final String name;
  final String description;
  final List<String> doctors;
  final String icon;
  final List<String> specialties;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.doctors,
    required this.icon,
    this.specialties = const [],
  });
}
