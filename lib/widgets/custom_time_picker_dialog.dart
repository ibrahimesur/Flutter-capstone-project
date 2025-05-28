import 'package:flutter/material.dart';

// HealthApp renklerine erişmek için main.dart dosyasını import ediyoruz
import '../main.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late int selectedHour;
  late int selectedMinute;
  final List<int> hours = List.generate(24, (index) => index);
  final List<int> minutes = List.generate(12, (index) => index * 5);

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
    selectedMinute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Saat Seçin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HealthApp.primaryColor,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Saat seçici
              SizedBox(
                height: 200,
                width: 70,
                child: ListWheelScrollView(
                  controller: FixedExtentScrollController(
                    initialItem: selectedHour,
                  ),
                  itemExtent: 40,
                  physics: FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedHour = index;
                    });
                  },
                  children: hours.map((hour) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedHour == hour
                            ? HealthApp.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        hour.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: selectedHour == hour ? 24 : 20,
                          fontWeight: selectedHour == hour
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedHour == hour
                              ? HealthApp.primaryColor
                              : Colors.black54,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Text(
                ':',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: HealthApp.primaryColor,
                ),
              ),
              // Dakika seçici
              SizedBox(
                height: 200,
                width: 70,
                child: ListWheelScrollView(
                  controller: FixedExtentScrollController(
                    initialItem: minutes.indexOf(
                      (selectedMinute ~/ 5) * 5,
                    ),
                  ),
                  itemExtent: 40,
                  physics: FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMinute = minutes[index];
                    });
                  },
                  children: minutes.map((minute) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedMinute == minute
                            ? HealthApp.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        minute.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: selectedMinute == minute ? 24 : 20,
                          fontWeight: selectedMinute == minute
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedMinute == minute
                              ? HealthApp.primaryColor
                              : Colors.black54,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onTimeSelected(
                    TimeOfDay(hour: selectedHour, minute: selectedMinute),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HealthApp.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Seç',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 