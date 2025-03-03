import 'package:flutter/material.dart';
import '../model/booking.dart';

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners(); 
  }

  void removeBooking(int index) {
    _bookings.removeAt(index);
    notifyListeners();
  }
}
