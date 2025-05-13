import 'package:oftamoloska_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/novost.dart';
import '../providers/novosti_provider.dart';

class NovostDetailScreen extends StatefulWidget {
  final Novost? novost;
  const NovostDetailScreen({Key? key, this.novost}) : super(key: key);

  @override
  State<NovostDetailScreen> createState() => _NovostDetailScreenState();
}

class _NovostDetailScreenState extends State<NovostDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NovostiProvider _novostProvider;
  final _dateController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'naslov': widget.novost?.naslov,
      'sadrzaj': widget.novost?.sadrzaj,
      'datumObjave': widget.novost?.datumObjave,
    };
    _novostProvider = context.read<NovostiProvider>();
    initForm();
  }

  void _setCurrentDate() {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    _dateController.text = formattedDate;
  }

  Future<void> initForm() async {
    setState(() {
      isLoading = false;
    });
    _setCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.novost?.naslov ?? "News",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildForm(),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _handleSubmit,
                        icon: const Icon(Icons.save),
                        label: const Text("Save"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'naslov',
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormBuilderTextField(
                  name: 'sadrzaj',
                  decoration: const InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'datumObjave',
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Publication Date",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    _formKey.currentState?.saveAndValidate();
    var request = Map.from(_formKey.currentState!.value);

    try {
      if (widget.novost == null) {
        await _novostProvider.insert(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News successfully added.'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState?.reset();
        Navigator.pop(context, 'reload');
      } else {
        await _novostProvider.update(widget.novost!.novostId!, request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('News successfully updated.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, 'reload');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }
}
