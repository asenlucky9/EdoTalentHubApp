// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 1;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      id: fields[0] as String,
      customerId: fields[1] as String,
      artistId: fields[2] as String,
      eventType: fields[3] as String,
      eventDate: fields[4] as DateTime,
      eventLocation: fields[5] as String,
      duration: fields[6] as int,
      totalAmount: fields[7] as double,
      status: fields[8] as String,
      specialRequirements: fields[9] as String?,
      createdAt: fields[10] as DateTime?,
      updatedAt: fields[11] as DateTime?,
      paymentStatus: fields[12] as String?,
      paymentMethod: fields[13] as String?,
      transactionId: fields[14] as String?,
      customerName: fields[15] as String?,
      customerPhone: fields[16] as String?,
      customerEmail: fields[17] as String?,
      artistName: fields[18] as String?,
      artistPhone: fields[19] as String?,
      artistEmail: fields[20] as String?,
      selectedMCId: fields[21] as String?,
      selectedMCName: fields[22] as String?,
      selectedVideographerId: fields[23] as String?,
      selectedVideographerName: fields[24] as String?,
      selectedVenueId: fields[25] as String?,
      selectedVenueName: fields[26] as String?,
      activityLog: (fields[27] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      referenceNumber: fields[28] as String,
      artistImageUrl: fields[29] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.artistId)
      ..writeByte(3)
      ..write(obj.eventType)
      ..writeByte(4)
      ..write(obj.eventDate)
      ..writeByte(5)
      ..write(obj.eventLocation)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.totalAmount)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.specialRequirements)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.paymentStatus)
      ..writeByte(13)
      ..write(obj.paymentMethod)
      ..writeByte(14)
      ..write(obj.transactionId)
      ..writeByte(15)
      ..write(obj.customerName)
      ..writeByte(16)
      ..write(obj.customerPhone)
      ..writeByte(17)
      ..write(obj.customerEmail)
      ..writeByte(18)
      ..write(obj.artistName)
      ..writeByte(19)
      ..write(obj.artistPhone)
      ..writeByte(20)
      ..write(obj.artistEmail)
      ..writeByte(21)
      ..write(obj.selectedMCId)
      ..writeByte(22)
      ..write(obj.selectedMCName)
      ..writeByte(23)
      ..write(obj.selectedVideographerId)
      ..writeByte(24)
      ..write(obj.selectedVideographerName)
      ..writeByte(25)
      ..write(obj.selectedVenueId)
      ..writeByte(26)
      ..write(obj.selectedVenueName)
      ..writeByte(27)
      ..write(obj.activityLog)
      ..writeByte(28)
      ..write(obj.referenceNumber)
      ..writeByte(29)
      ..write(obj.artistImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
