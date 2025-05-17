import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/styles.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter event name';
    }
    return null;
  }

  String? _validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter budget';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validateDateTime() {
    if (_selectedDate == null) {
      return 'Please select a date';
    }
    if (_selectedTime == null) {
      return 'Please select a time';
    }
    return null;
  }

  CollectionReference eventList = FirebaseFirestore.instance.collection(
    "eventList",
  );

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _validateDateTime() == null) {
      try {
        await FirebaseFirestore.instance.collection('events').add({
          'name': _nameController.text,
          'budget': double.parse(_budgetController.text),
          'date': _selectedDate?.toIso8601String().split('T').first ?? '',
          'time': _selectedTime?.format(context) ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'isCompleted': false,
          'debug_visible': true,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully')),
          );
          Navigator.pop(context); // Optional: go back to previous screen
        }
      } catch (e) {
        print('Firestore error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Event',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.defaultPadding),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              ),
              padding: const EdgeInsets.all(AppStyles.defaultPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Placeholder for illustration
                    Image.asset("images/event-list.png", height: 120),

                    const SizedBox(height: 16),
                    const Text(
                      'Create a new event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Set up an event and start planning it',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: const Icon(Icons.calendar_today),
                                ),
                                controller: TextEditingController(
                                  text:
                                      _selectedDate == null
                                          ? ''
                                          : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                                ),
                                validator: (_) => _validateDateTime(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() => _selectedTime = time);
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Time',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: const Icon(Icons.access_time),
                                  hintText:
                                      _selectedTime == null
                                          ? ''
                                          : _selectedTime!.format(context),
                                ),
                                controller: TextEditingController(
                                  text:
                                      _selectedTime == null
                                          ? ''
                                          : _selectedTime!.format(context),
                                ),
                                validator: (_) => _validateDateTime(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Budget',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateBudget,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppStyles.smallBorderRadius,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              AppStyles.smallBorderRadius,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'CREATE',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
      ),
    );
  }
}
