class ProfileEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final String role;
  final bool isActive;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.isActive,
  });
}