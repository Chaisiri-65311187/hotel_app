import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'provider/bookingprovider.dart';
import '../model/booking.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _guestsController = TextEditingController();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  String _selectedRoomType = 'Standard';

  @override
  void dispose() {
    _nameController.dispose();
    _guestsController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

void _addBooking() {
  if (_formKey.currentState!.validate()) {
    final newBooking = Booking(
      name: _nameController.text,
      guests: int.parse(_guestsController.text),
      checkIn: _checkInController.text,
      checkOut: _checkOutController.text,
      roomType: _selectedRoomType,
    );

    Provider.of<BookingProvider>(context, listen: false).addBooking(newBooking);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เพิ่มข้อมูลสำเร็จ!')),
    );
    Navigator.pop(context);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.purple.shade700,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: const Text(
            'ฟอร์มการจองโรงแรม',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              TextFormField(
                controller: _guestsController,
                decoration: const InputDecoration(labelText: 'จำนวนผู้เข้าพัก'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกจำนวน' : null,
              ),
              TextFormField(
                controller: _checkInController,
                decoration: const InputDecoration(labelText: 'วันที่เช็คอิน'),
                readOnly: true,
                onTap: () => _selectDate(context, _checkInController),
              ),
              TextFormField(
                controller: _checkOutController,
                decoration: const InputDecoration(labelText: 'วันที่เช็คเอาท์'),
                readOnly: true,
                onTap: () => _selectDate(context, _checkOutController),
              ),
              DropdownButtonFormField(
                value: _selectedRoomType,
                items: ['Standard', 'Deluxe', 'Suite']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRoomType = value!),
                decoration: const InputDecoration(labelText: 'ประเภทห้อง'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBooking,
                child: const Text('เพิ่มข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
