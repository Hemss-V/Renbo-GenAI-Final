import 'package:flutter/material.dart';
import 'package:renbo/utils/theme.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sessions',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUpcomingSession(),
              const SizedBox(height: 20),
              const Text(
                'All Sessions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildSessionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSession() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Session',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSessionCard(
              name: 'Selena V',
              specialty: 'Clinical Psychology',
              time: '7:00 PM - 8:00 PM',
              isUpcoming: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList() {
    return Column(
      children: [
        _buildSessionCard(
          name: 'Selena V',
          specialty: 'Clinical Psychology',
          time: 'Flat March 28',
        ),
        _buildSessionCard(
          name: 'Jessica R',
          specialty: 'Counseling',
          time: 'Flat March 27',
        ),
      ],
    );
  }

  Widget _buildSessionCard({
    required String name,
    required String specialty,
    required String time,
    bool isUpcoming = false,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.lightGray,
              child: Icon(Icons.person, color: AppTheme.mediumGray),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            if (isUpcoming)
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Reschedule'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Join Now'),
                  ),
                ],
              )
            else
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Re-book'),
              ),
          ],
        ),
      ),
    );
  }
}
