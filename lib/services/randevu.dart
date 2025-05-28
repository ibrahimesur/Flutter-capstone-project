class Randevu {
  final String id;
  final String hastaId;
  final String department;
  final String doctor;
  final DateTime date;
  final String time;

  Randevu({
    required this.id,
    required this.hastaId,
    required this.department,
    required this.doctor,
    required this.date,
    required this.time,
  });
}

// Tüm randevuların tutulduğu global liste
List<Randevu> globalRandevuList = []; 