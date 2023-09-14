// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:btsverse/utils/color.dart';
import 'package:btsverse/widgets/drawer.dart';
import 'package:btsverse/widgets/long_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryReport extends StatefulWidget {
  final String storyId;
  const StoryReport({Key? key, required this.storyId}) : super(key: key);

  @override
  _StoryReportState createState() => _StoryReportState();
}

class _StoryReportState extends State<StoryReport> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('story').doc(widget.storyId);
      await postRef.collection('reports').add({
        'reason': _selectedReason,
        'description': _descriptionController.text
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report received, thank you!')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
            purple,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'REPORT',
            style: TextStyle(color: Colors.white, fontFamily: 'Sen'),
          ),
          centerTitle: true,
        ),
        drawer: const DrawerScreen(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please select a reason for your report:',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: 'Sen'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedReason,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedReason = newValue;
                        });
                      },
                      items: <String>[
                        'Inappropriate content',
                        'Spam',
                        'Hate speech',
                        'Other'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.purple.shade200),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Select a reason',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sen',
                          )),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Please describe the issue:',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: 'Sen'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Sen'),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: LongButton(
                        text: 'SUBMIT',
                        press: _submitReport,
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
