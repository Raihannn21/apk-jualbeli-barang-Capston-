import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../models/location.dart';
import '../../models/user_address.dart';
import '../../services/address_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';

class AddEditAddressScreen extends StatefulWidget {
  final UserAddress? address;
  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _labelController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _locationSearchController = TextEditingController();

  int? _selectedCityId;
  String? _selectedCityName;
  String? _selectedProvinceName;
  String? _selectedPostalCode;
  bool _isPrimary = false;

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      final adr = widget.address!;
      _labelController.text = adr.label;
      _recipientNameController.text = adr.recipientName;
      _phoneNumberController.text = adr.phoneNumber;
      _addressController.text = adr.address;
      _locationSearchController.text = '${adr.city}, ${adr.province}';
      _selectedCityId = adr.cityId;
      _selectedCityName = adr.city;
      _selectedProvinceName = adr.province;
      _selectedPostalCode = adr.postalCode;
      _isPrimary = adr.isPrimary;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _recipientNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _locationSearchController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCityId == null) {
        NotificationService.showInfoNotification(
            context, 'Harap pilih lokasi dari daftar pencarian.');
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final addressData = {
          'label': _labelController.text,
          'recipient_name': _recipientNameController.text,
          'phone_number': _phoneNumberController.text,
          'address': _addressController.text,
          'city_id': _selectedCityId.toString(),
          'city': _selectedCityName,
          'province': _selectedProvinceName,
          'postal_code': _selectedPostalCode,
          'is_primary': _isPrimary,
        };

        if (widget.address != null) {
          await AddressService().updateAddress(widget.address!.id, addressData);
        } else {
          await AddressService().addAddress(addressData);
        }

        if (mounted) {
          NotificationService.showSuccessNotification(
              context, 'Alamat berhasil disimpan!');
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          NotificationService.showErrorNotification(context, e.toString());
        }
      } finally {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.address == null ? 'Tambah Alamat Baru' : 'Edit Alamat'),
      ),
      body: Form(
        key: _formKey,
        child: AnimationLimiter(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _buildSectionTitle('Info Kontak Penerima'),
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                      labelText: 'Label Alamat (cth: Rumah, Kantor)',
                      border: OutlineInputBorder()),
                  validator: (value) =>
                      value!.isEmpty ? 'Label tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _recipientNameController,
                  decoration: const InputDecoration(
                      labelText: 'Nama Lengkap Penerima',
                      border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty
                      ? 'Nama penerima tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                      labelText: 'Nomor HP Penerima',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Nomor HP tidak boleh kosong' : null,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                _buildSectionTitle('Detail Alamat'),
                TypeAheadFormField<Location>(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _locationSearchController,
                      decoration: const InputDecoration(
                        labelText: 'Cari Kecamatan / Kota',
                        hintText: 'Mulai ketik nama lokasi...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      )),
                  suggestionsCallback: (pattern) async {
                    return await _locationService.searchLocations(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.subdistrictName),
                      subtitle: Text(
                          '${suggestion.cityName}, ${suggestion.provinceName}'),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _locationSearchController.text =
                          '${suggestion.subdistrictName}, ${suggestion.cityName}';
                      _selectedCityId = suggestion.id;
                      _selectedCityName = suggestion.cityName;
                      _selectedProvinceName = suggestion.provinceName;
                      _selectedPostalCode = suggestion.zipCode;
                    });
                  },
                  noItemsFoundBuilder: (context) => const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Lokasi tidak ditemukan, coba kata kunci lain.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || _selectedCityId == null) {
                      return 'Harap pilih lokasi dari daftar';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller:
                      TextEditingController(text: _selectedProvinceName ?? ''),
                  decoration: const InputDecoration(
                      labelText: 'Provinsi', border: OutlineInputBorder()),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller:
                      TextEditingController(text: _selectedCityName ?? ''),
                  decoration: const InputDecoration(
                      labelText: 'Kota/Kabupaten',
                      border: OutlineInputBorder()),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller:
                      TextEditingController(text: _selectedPostalCode ?? ''),
                  decoration: const InputDecoration(
                      labelText: 'Kode Pos', border: OutlineInputBorder()),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: 'Nama Jalan, Gedung, No. Rumah',
                      border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty
                      ? 'Detail alamat tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Jadikan Alamat Utama'),
                  value: _isPrimary,
                  onChanged: (bool value) => setState(() => _isPrimary = value),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  tileColor: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))
                      : const Text('Simpan Alamat'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
