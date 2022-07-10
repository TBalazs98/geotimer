class Alarm{
  int? id;
  double lat;
  double lon;
  int r;
  String city;
  double frequency;
  int isActive;

  Alarm({this.id, this.lat = 47.4979, this.lon = 19.0402, this.r = 10, this.city = "ASD", this.frequency = 60, this.isActive = 0});
  
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'lat': lat,
      'lon': lon,
      'r': r,
      'city': city,
      'frequency': frequency,
      'isActive': isActive
    };
   }

  static Alarm fromMap(Map<String, dynamic> data){
    return Alarm(id: data['id'], lat: data['lat'], lon: data['lon'], r: data['r'], city: data['city'], frequency: data['frequency'], isActive: data['isActive']);
  }


}