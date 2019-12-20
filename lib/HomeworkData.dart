import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class HomeworkData{

  String Assignment;
  String Points;

  HomeworkData({this.Assignment, this.Points}){
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$HomeworkDataFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory HomeworkData.fromJson(Map<String, dynamic> json) {
    return HomeworkData(Assignment: json['Assignment'], Points: json['Points']);
  }
  
    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$HomeworkDataToJson`.
    Map<String, dynamic> toJson() => _$HomeworkDataToJson(this);
  
  
    Map<String, dynamic> _$HomeworkDataToJson(HomeworkData instance) => <String, dynamic>{
      'Assignment': instance.Assignment,
      'Points': instance.Points,
    };
 
  
}