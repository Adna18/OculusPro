import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/korisnik.dart';
import '../providers/korisnik_provider.dart';

class PacijentiScreen extends StatefulWidget {
  const PacijentiScreen({Key? key}) : super(key: key);

  @override
  State<PacijentiScreen> createState() => _PacijentiScreenState();
}

class _PacijentiScreenState extends State<PacijentiScreen> {
  late KorisniciProvider _korisniciProvider;
  List<Korisnik> _allUsers = [];
  List<Korisnik> _filteredUsers = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      var result = await _korisniciProvider.get();

      for (var u in result.result) {
        print('${u.ime} ${u.prezime}');
      }

      setState(() {
        _allUsers = result.result;
        _filteredUsers = _allUsers.where((user) => user.tipKorisnikaId == 2).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    final filtered = _allUsers.where((user) {
      final firstName = user.ime?.toLowerCase() ?? '';
      final lastName = user.prezime?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return (firstName.contains(searchLower) || lastName.contains(searchLower))&&user.tipKorisnikaId==2;
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: Colors.green[800],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Search patients by first or last name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: _filterUsers,
                      ),
                    ),
                    Expanded(
                      child: _filteredUsers.isEmpty
                          ? Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? 'No patients to display'
                                    : 'No patients found for "$_searchQuery"',
                                style: const TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = _filteredUsers[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    title: Text('${user.ime ?? ''} ${user.prezime ?? ''}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (user.tipKorisnika?.tip != null)
                                          Text('Type: ${user.tipKorisnika!.tip}'),
                                        if (user.email != null)
                                          Text('Email: ${user.email}'),
                                        if (user.telefon != null)
                                          Text('Phone: ${user.telefon}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
