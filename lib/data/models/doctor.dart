/// Doctor / clinician profile.
class Doctor {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String hospital;
  final String photoUrl;

  const Doctor({
    required this.id,
    required this.name,
    required this.email,
    this.specialization = 'Pulmonology',
    this.hospital = 'City General Hospital',
    this.photoUrl = '',
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String get firstName => name.split(' ').first;
}
