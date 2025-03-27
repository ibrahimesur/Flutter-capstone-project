class HospitalStaff {
  final String name;
  final String title;
  final String department;
  final String role;
  final String imageUrl;
  final String staffId;

  HospitalStaff({
    required this.name,
    required this.title,
    required this.department,
    required this.role,
    this.imageUrl = 'assets/images/staff_placeholder.png',
    required this.staffId,
  });
}
