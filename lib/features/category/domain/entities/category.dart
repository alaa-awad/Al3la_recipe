

import 'package:equatable/equatable.dart';

class Category extends Equatable{

  final String uId;
  final String name;
 final String? image;

 const Category({required this.uId, required this.name,this.image});


  @override
  List<Object?> get props => [uId,name,image];

}