import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _kilometersController = TextEditingController();
  final _mileageController = TextEditingController();
  final _engineController = TextEditingController();
  final _powerController = TextEditingController();
  final _seatsController = TextEditingController();
  final _nameController = TextEditingController();

  String _fuelType = 'Petrol';
  String _transmission = 'Manual';
  String _ownerType = 'First';
  String _location = 'Mumbai';

  Future<void> _predictPrice() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://linear-regression-model-sain.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Year': int.parse(_yearController.text),
          'Kilometers_Driven': int.parse(_kilometersController.text),
          'Fuel_Type': _fuelType,
          'Transmission': _transmission,
          'Owner_Type': _ownerType,
          'Mileage': _mileageController.text,
          'Engine': _engineController.text,
          'Power': _powerController.text,
          'Seats': double.parse(_seatsController.text),
          'Location': _location,
          'Name': _nameController.text,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        Navigator.pushNamed(
          context,
          '/result',
          arguments: {
            'predicted_price': result['predicted_price'],
            'details': {
              'Year': _yearController.text,
              'Kilometers_Driven': _kilometersController.text,
              'Fuel_Type': _fuelType,
              'Transmission': _transmission,
              'Owner_Type': _ownerType,
              'Mileage': _mileageController.text,
              'Engine': _engineController.text,
              'Power': _powerController.text,
              'Seats': _seatsController.text,
              'Location': _location,
              'Name': _nameController.text,
            },
          },
        );
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Price Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  hintText: 'e.g., 2015',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1990 || year > 2023) {
                    return 'Please enter a valid year (1990-2023)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kilometersController,
                decoration: const InputDecoration(
                  labelText: 'Kilometers Driven',
                  hintText: 'e.g., 50000',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the kilometers driven';
                  }
                  final kilometers = int.tryParse(value);
                  if (kilometers == null || kilometers < 0) {
                    return 'Please enter a valid number of kilometers';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _fuelType,
                decoration: const InputDecoration(labelText: 'Fuel Type'),
                items:
                    ['CNG', 'Diesel', 'Petrol', 'LPG']
                        .map(
                          (fuel) =>
                              DropdownMenuItem(value: fuel, child: Text(fuel)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _fuelType = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _transmission,
                decoration: const InputDecoration(labelText: 'Transmission'),
                items:
                    ['Manual', 'Automatic']
                        .map(
                          (transmission) => DropdownMenuItem(
                            value: transmission,
                            child: Text(transmission),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _transmission = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _ownerType,
                decoration: const InputDecoration(labelText: 'Owner Type'),
                items:
                    ['First', 'Second']
                        .map(
                          (owner) => DropdownMenuItem(
                            value: owner,
                            child: Text(owner),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _ownerType = value!;
                  });
                },
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(
                  labelText: 'Mileage',
                  hintText: 'e.g., 18.9 kmpl',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mileage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _engineController,
                decoration: const InputDecoration(
                  labelText: 'Engine',
                  hintText: 'e.g., 1197 CC',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the engine';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _powerController,
                decoration: const InputDecoration(
                  labelText: 'Power',
                  hintText: 'e.g., 81.86 bhp',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the power';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _seatsController,
                decoration: const InputDecoration(
                  labelText: 'Seats',
                  hintText: 'e.g., 5',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of seats';
                  }
                  final seats = double.tryParse(value);
                  if (seats == null || seats < 2 || seats > 10) {
                    return 'Please enter a valid number of seats (2-10)';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                items:
                    [
                          'Mumbai',
                          'Pune',
                          'Chennai',
                          'Coimbatore',
                          'Hyderabad',
                          'Jaipur',
                          'Kochi',
                          'Kolkata',
                          'Delhi',
                          'Bangalore',
                        ]
                        .map(
                          (location) => DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _location = value!;
                  });
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Car Name',
                  hintText: 'e.g., Maruti Swift VXI',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predictPrice,
                child: const Text('Predict Price'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
