import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/event_model.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;

  const AddEventScreen({super.key, this.event});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  // REMOVED: final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _linkController = TextEditingController();
  final _seatsController = TextEditingController();

  // New: Dropdown State
  String? _selectedLocation;

  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descController.text = widget.event!.description;
      // Set dropdown value (ensure it exists in the list, or handle custom)
      if (AppConstants.campusLocations.containsKey(widget.event!.location)) {
        _selectedLocation = widget.event!.location;
      }
      _categoryController.text = widget.event!.category;
      _linkController.text = widget.event!.linkUrl ?? '';
      _seatsController.text = widget.event!.totalSeats?.toString() ?? '';
      _selectedDate = widget.event!.date;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      int? seats;
      if (_seatsController.text.isNotEmpty) {
        seats = int.tryParse(_seatsController.text);
      }

      final event = Event(
        id: widget.event?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        date: _selectedDate,
        // Use selected location from dropdown
        location: _selectedLocation!,
        category: _categoryController.text,
        participationStatus: widget.event?.participationStatus ?? 'None',
        linkUrl: _linkController.text.isNotEmpty ? _linkController.text : null,
        totalSeats: seats,
        seatsTaken: widget.event?.seatsTaken ?? 0,
      );

      Provider.of<AppProvider>(context, listen: false).addEvent(event);
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.event != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Event' : 'Create Event',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: AppConstants.gradientColors),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 20,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppConstants.gradientColors),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(_titleController, 'Title', Icons.title),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _descController,
                          'Description',
                          Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(
                                Icons.calendar_today,
                                color: AppColors.primary,
                              ),
                            ),
                            child: Text(
                              DateFormat(
                                'EEEE, MMM d, yyyy',
                              ).format(_selectedDate),
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              // REPLACED: Text Field with Dropdown
                              child: DropdownButtonFormField<String>(
                                value: _selectedLocation,
                                isExpanded:
                                    true, // FIXED: Added this to prevent overflow
                                items: AppConstants.campusLocations.keys.map((
                                  loc,
                                ) {
                                  return DropdownMenuItem(
                                    value: loc,
                                    child: Text(
                                      loc,
                                      overflow: TextOverflow
                                          .ellipsis, // Added text handling
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedLocation = val),
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                  ),
                                ),
                                validator: (v) => v == null ? 'Required' : null,
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                _categoryController,
                                'Category',
                                Icons.label,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _seatsController,
                          'Available Seats (Optional)',
                          Icons.event_seat,
                          isRequired: false,
                          isNumber: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _linkController,
                          'Link (Optional)',
                          Icons.link,
                          isRequired: false,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              isEditing ? 'UPDATE' : 'PUBLISH',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    bool isRequired = true,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
      validator: isRequired ? (v) => v!.isEmpty ? 'Required' : null : null,
    );
  }
}
