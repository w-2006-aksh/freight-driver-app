class ApiConfig {
  static const baseUrl = "http://172.20.10.3:8000";
  static const tripBase = "$baseUrl/api/trip";

  static Uri tripStatus(String bidNo) =>
      Uri.parse("$tripBase/bids/$bidNo/status");

  static Uri tripPickup(String bidNo) =>
      Uri.parse("$tripBase/bids/$bidNo/pickup");

  static Uri tripLocation(String bidNo) =>
      Uri.parse("$tripBase/bids/$bidNo/location");

  static Uri tripDelivery(String bidNo) =>
      Uri.parse("$tripBase/bids/$bidNo/delivery");
}
