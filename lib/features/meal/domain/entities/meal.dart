import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String uId;
  final String name;
  final String ingredients;
  final String? describe;
  final String? note;
  final String? image;

 const Meal({
    required this.uId,
    required this.name,
    required this.ingredients,
    this.image,
    this.describe,
    this.note,
  });

  @override
  List<Object?> get props => [uId, name, describe, deprecated, note, image];
}
