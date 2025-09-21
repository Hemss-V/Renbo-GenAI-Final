import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/journal_storage.dart';
import 'journal_detail.dart';
import 'journal_edit_screen.dart';

class JournalEntriesPage extends StatefulWidget {
  const JournalEntriesPage({Key? key}) : super(key: key);

  @override
  State<JournalEntriesPage> createState() => _JournalEntriesPageState();
}

class _JournalEntriesPageState extends State<JournalEntriesPage> {
  late Future<List<JournalEntry>> _entries;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entries = JournalStorage.getEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal Entries')),
      body: FutureBuilder<List<JournalEntry>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No journal entries available.'));
          } else {
            final entries = snapshot.data!;

            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];

                return ListTile(
                  key: Key(entry.getId),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.content.isEmpty
                              ? "Journal Entry"
                              : entry.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Show a mic icon if there's a recording
                      if (entry.audioPath != null)
                        const Icon(Icons.mic, color: Colors.grey, size: 18),
                    ],
                  ),
                  subtitle: Text(entry.timestamp.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            JournalDetailScreen(entry: entry),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EDIT BUTTON
                      IconButton(
                        icon:
                            const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JournalEditScreen(entry: entry),
                            ),
                          ).then((_) =>
                              _loadEntries()); // Refresh list after edit
                        },
                      ),
                      // DELETE BUTTON
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.redAccent),
                        onPressed: () async {
                          await JournalStorage.deleteEntry(entry.getId);
                          _loadEntries(); // Refresh list after deleting
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}