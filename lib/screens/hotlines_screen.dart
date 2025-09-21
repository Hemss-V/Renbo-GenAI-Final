import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Hotline {
  final String name; // e.g. "KIRAN Mental Health Helpline"
  final String
      description; // e.g. "For mental health support, stress, anxiety, depression"
  final String contactPerson; // e.g. "Trained Mental Health Counselors"
  final String phone;

  Hotline({
    required this.name,
    required this.description,
    required this.contactPerson,
    required this.phone,
  });
}

class HotlinesScreen extends StatelessWidget {
  HotlinesScreen({super.key});

  final List<Hotline> hotlines = [
    Hotline(
      name: "KIRAN Mental Health Helpline",
      description:
          "24/7 support for stress, anxiety, depression, suicidal thoughts.",
      contactPerson: "Trained Mental Health Counselors",
      phone: "18005990019",
    ),
    Hotline(
      name: "Vandrevala Foundation Helpline",
      description:
          "Support for emotional distress, depression, suicidal thoughts.",
      contactPerson: "Counselors at Vandrevala Foundation",
      phone: "18602662345",
    ),
    Hotline(
      name: "Snehi (Delhi-based NGO)",
      description:
          "Emotional support for suicide prevention & crisis intervention.",
      contactPerson: "Snehi Volunteer Counselors",
      phone: "9582208181",
    ),
  ];

  /// Initiates a phone call to the provided [phoneNumber].
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // In a real app, you might want to show a gentle error message
      // to the user here, e.g., using a SnackBar.
      debugPrint('Could not launch phone dialer for $phoneNumber');
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mental Wellness Hotlines",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            shadowColor: Colors.deepPurple.withOpacity(0.2),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              title: Text(
                hotline.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotline.description),
                    const SizedBox(height: 4),
                    Text(
                      "Contact: ${hotline.contactPerson}",
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 28),
                tooltip: 'Call ${hotline.phone}',
                onPressed: () => _makePhoneCall(hotline.phone),
              ),
            ),
          );
        },
      ),
    );
  }
}
