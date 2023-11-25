// ignore_for_file: non_constant_identifier_names, file_names

class Customer {
  String AdminName,
      CustomerID,
      CustomerName,
      CardNumber,
      IdentityNumber,
      PhoneNumber,
      Country,
      CardType;
  DateTime MemberShipDate, Birthday;
  Customer({
    required this.AdminName,
    required this.CustomerName,
    required this.CustomerID,
    required this.CardNumber,
    required this.IdentityNumber,
    required this.PhoneNumber,
    required this.Country,
    required this.CardType,
    required this.MemberShipDate,
    required this.Birthday,
  });
  Map<String, dynamic> toMap() {
    return {
      'AdminName': AdminName,
      'CustomerID': CustomerID,
      'CustomerName': CustomerName,
      'CardNumber': CardNumber,
      'IdentityNumber': IdentityNumber,
      'PhoneNumber': PhoneNumber,
      'Country': Country,
      'CardType': CardType,
      'MemberShipDate': MemberShipDate.toIso8601String(),
      'Birthday': Birthday.toIso8601String(),
    };
  }

  Map<String, dynamic> toMapWithType() {
    return {
      'fields': {
        'AdminName': {'stringValue': AdminName},
        'CustomerID': {'stringValue': CustomerID},
        'CustomerName': {'stringValue': CustomerName},
        'CardNumber': {'stringValue': CardNumber},
        'IdentityNumber': {'stringValue': IdentityNumber},
        'PhoneNumber': {'stringValue': PhoneNumber},
        'Country': {'stringValue': Country},
        'CardType': {'stringValue': CardType},
        'MemberShipDate': {'stringValue': MemberShipDate.toIso8601String()},
        'Birthday': {'stringValue': Birthday.toIso8601String()},
      }
    };
  }
}
