import 'provider/bookingprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'formScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
  create: (context) {
    return BookingProvider(); 
  },
),
      ],
      child: MaterialApp(
        title: 'Hotel',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'รายการจองโรงแรม'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            'รายการจองโรงแรม',
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
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return ListView.builder(
            itemCount: bookingProvider.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingProvider.bookings[index];

              return Dismissible(
                key: Key(booking.name), 
                direction: DismissDirection.endToStart, 
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  bookingProvider.removeBooking(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ลบรายการสำเร็จ!')),
                  );
                },
                child: Card(
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 4, // เพิ่มเงาให้ดูมีมิติ
  child: ListTile(
    contentPadding: const EdgeInsets.all(16),
    leading: Icon(Icons.hotel, color: Colors.purple.shade700),
    title: Text(
      booking.name,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      "ผู้เข้าพัก: ${booking.guests} | ห้อง: ${booking.roomType}",
      style: TextStyle(color: Colors.black54),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "เช็คอิน",
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(
          booking.checkIn,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ),
),
              );
            },
          );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormScreen()),
              );
            },
            label: const Text(
              'เพิ่มรายการจอง',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.purple.shade700,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

