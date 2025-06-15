import 'dart:convert';
import 'dart:io';
import 'package:oftamoloska_desktop/models/product.dart';
import 'package:oftamoloska_desktop/models/SearchResult.dart';
import 'package:oftamoloska_desktop/models/vrste_proizvoda.dart';
import 'package:oftamoloska_desktop/models/recenzija.dart';  
import 'package:oftamoloska_desktop/providers/product_provider.dart';
import 'package:oftamoloska_desktop/providers/vrste_proizvoda_provider.dart';
import 'package:oftamoloska_desktop/providers/recenzija_provider.dart';  
import 'package:oftamoloska_desktop/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ProductDetailScreen extends StatefulWidget {
  Product? product;
  ProductDetailScreen({super.key, this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late VrsteProizvodaProvider _vrsteProizvodaProvider;
  late ProductProvider _productProvider;
  late RecenzijaProvider _recenzijaProvider;  

  SearchResult<VrsteProizvoda>? VrsteProizvodaResult;
  List<Recenzija> _recenzije = [];  
  bool isLoading = true;

  File? _image;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'sifra': widget.product?.sifra,
      'naziv': widget.product?.naziv,
      'cijena': widget.product?.cijena?.toString(),
      'dostupno': widget.product?.dostupno?.toString(),
      'vrstaId': widget.product?.vrstaId?.toString(),
    };

    _vrsteProizvodaProvider = context.read<VrsteProizvodaProvider>();
    _productProvider = context.read<ProductProvider>();
    _recenzijaProvider = RecenzijaProvider();  

    initForm();
  }

  Future initForm() async {
    VrsteProizvodaResult = await _vrsteProizvodaProvider.get();
    
    
    if (widget.product?.proizvodId != null) {
      var result = await _recenzijaProvider.get(filter: {
        'proizvodId': widget.product!.proizvodId
      });
      _recenzije = result.result;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          SizedBox(height: 20),  
          _buildRecenzije(),       
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final isNameValid =
                          _formKey.currentState!.fields['naziv']?.validate();
                      final isCodeValid =
                          _formKey.currentState!.fields['sifra']?.validate();
                      final isPriceValid =
                          _formKey.currentState!.fields['cijena']?.validate();
                      final isTypeValid =
                          _formKey.currentState!.fields['vrstaId']?.validate();

                      if (isNameValid == null ||
                          !isNameValid ||
                          isCodeValid == null ||
                          !isCodeValid ||
                          isPriceValid == null ||
                          !isPriceValid ||
                          isTypeValid == null ||
                          !isTypeValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please fix all required fields before saving.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_base64Image == null || _base64Image!.isEmpty) {
                        _base64Image = base64Encode(
                            File('assets/images/no-image.jpg')
                                .readAsBytesSync());
                      }

                      _formKey.currentState?.saveAndValidate();
                      var request =
                          Map<String, dynamic>.from(_formKey.currentState!.value);
                      request['slika'] = _base64Image;

                      try {
                        if (widget.product == null) {
                          await _productProvider.insert(request);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Product successfully added.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _formKey.currentState?.reset();
                          Navigator.pop(context, 'reload');
                        } else {
                          await _productProvider.update(
                              widget.product!.proizvodId!, request);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Product successfully updated'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context, 'reload');
                        }
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Save")),
              ],
            ),
          ),
        ],
      ),
      title: widget.product?.naziv ?? "Product details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Product code"),
                    name: 'sifra',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product code is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Product name"),
                    name: 'naziv',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown<String>(
                    name: 'vrstaId',
                    decoration: InputDecoration(
                      labelText: 'Product Type',
                      suffix: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey.currentState!.fields['vrstaId']?.reset();
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Type is required';
                      }
                      return null;
                    },
                    items: VrsteProizvodaResult?.result
                            .map((item) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center,
                                  value: item.vrstaId.toString(),
                                  child: Text(item.naziv ?? ""),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Price"),
                    name: 'cijena',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Price is required";
                      }
                      final cijena = double.tryParse(value);
                      if (cijena == null) {
                        return "Price must be a number";
                      }
                      if (cijena < 1 || cijena > 10000) {
                        return "Price must be between 1 and 10,000";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Select image"),
                    name: 'slika',
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        setState(() {
                          _image = file;
                          _base64Image = base64Encode(file.readAsBytesSync());
                        });
                      }
                    },
                    child: Text("Select image")),
              ],
            ),
          
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Image.file(
                    _image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecenzije() {
    if (_recenzije.isEmpty) {
      return Text("Nema recenzija za ovaj proizvod.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recenzije:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 10),
        ..._recenzije.map((rec) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(rec.sadrzaj ?? ""),
              subtitle: Text("Datum: ${rec.datum?.toLocal().toString().split(" ")[0] ?? ""}"),
              leading: Icon(Icons.comment),
            ),
          );
        }).toList(),

      ],
    );
  }
}
