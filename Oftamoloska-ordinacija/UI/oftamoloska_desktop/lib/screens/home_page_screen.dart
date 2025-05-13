import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oftamoloska_desktop/models/novost.dart';
import 'package:oftamoloska_desktop/providers/novosti_provider.dart';
import 'package:oftamoloska_desktop/screens/novost__detail_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final NovostiProvider _novostiProvider = NovostiProvider();
  List<Novost> _novosti = [];
  bool isLoading = true;
  final TextEditingController _naslovController = TextEditingController();
  bool _isSortAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchNovosti();
  }

  Future<void> _fetchNovosti() async {
    try {
      var result = await _novostiProvider.get(filter: {
        'naslov': _naslovController.text,
      });

      setState(() {
        _novosti = result.result;
        _sortNovosti();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortNovosti() {
    _novosti.sort((a, b) {
      if (_isSortAscending) {
        return a.datumObjave!.compareTo(b.datumObjave!);
      } else {
        return b.datumObjave!.compareTo(a.datumObjave!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          _buildSearch(),
          _buildDataListView(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _naslovController,
              onChanged: (_) => _fetchNovosti(),
              decoration: const InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: _isSortAscending ? 'older_to_newer' : 'newer_to_older',
              onChanged: (value) {
                setState(() {
                  _isSortAscending = value == 'older_to_newer';
                  _sortNovosti();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sort by date',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'older_to_newer',
                  child: Text('Older to Newer'),
                ),
                DropdownMenuItem(
                  value: 'newer_to_older',
                  child: Text('Newer to Older'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () async {
              var refresh = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NovostDetailScreen(novost: null),
                ),
              );
              if (refresh == 'reload') {
                _fetchNovosti();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Add"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    if (isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_novosti.isEmpty) {
      return const Expanded(
        child: Center(child: Text('No news found.')),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _novosti.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          var novost = _novosti[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              onTap: () async {
                var refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NovostDetailScreen(novost: novost),
                  ),
                );
                if (refresh == 'reload') {
                  _fetchNovosti();
                }
              },
              title: Text(
                novost.naslov ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(novost.sadrzaj ?? ''),
                    const SizedBox(height: 8),
                    Text(
                      'Published on: ${DateFormat('yyyy-MM-dd').format(novost.datumObjave ?? DateTime.now())}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(novost),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(Novost novost) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this news?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteNovost(novost);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNovost(Novost novost) async {
    try {
      await _novostiProvider.delete(novost.novostId);
      setState(() {
        _novosti.removeWhere((item) => item.novostId == novost.novostId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('News "${novost.naslov}" deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete "${novost.naslov}".')),
      );
    }
  }
}
