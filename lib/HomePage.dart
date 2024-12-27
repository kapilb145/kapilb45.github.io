import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'insurance_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  // final TextEditingController _otpController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());

  DateTime? _selectedDate;
  String? _otp; // Variable to store the OTP

  /// Function to generate OTP
  void _generateOTP() {
    String lastName = _lastNameController.text.trim();
    String dob = _dobController.text.trim();

    if (lastName.isEmpty || dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _otp = "1234"; // Generate a mock OTP (replace with actual logic)
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent successfully!')),
    );
  }




  /// Function to validate OTP
  void _validateOTP(String enteredOTP) {
    if (enteredOTP == _otp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verified successfully!')),
      );

      Navigator.push(context, MaterialPageRoute(builder: (context)=> InsuranceForm()));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  /// Function to pick a date from the date picker
  void _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Stack(
          clipBehavior: Clip.none, // Prevent clipping of the logo
          alignment: Alignment.center,
          children: [
            // White container with shadow
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 60), // Space for the overlapping image
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Last Name TextField
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // DOB TextField
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'DOB',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generateOTP,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ), // Call the generate OTP function
                    child: const Text('Generate OTP'),
                  ),
                  const SizedBox(height: 20),




                  // OTP Verification
                  if (_otp != null) ...[
                    const Text(
                      'Enter the 4-digit OTP:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextField(
                            controller: _otpControllers[index],
                            keyboardType: TextInputType.number,
                            maxLength: 1, // Limit to one character
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              counterText: "", // Hide counter
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).nextFocus(); // Move to next field
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus(); // Move to previous field
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (_otp != null) ...[
                    ElevatedButton(
                      onPressed: () {
                        _validateOTP(_otpControllers.map((controller) => controller.text).join());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Submit OTP'),
                    ),
                    const SizedBox(height: 20),
                  ],










                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't Receive Code?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: _generateOTP, // Handle OTP resend logic
                        child: const Text('Request Again'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Image overlapping the container
            const Positioned(
              top: -40, // Place the logo slightly above the container
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.orange,
                child: Icon(Icons.medical_services, size: 40, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );


  }
}