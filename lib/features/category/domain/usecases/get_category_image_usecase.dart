import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

class GetCategoryImageUseCase {
  final CategoryRepository categoryRepository;

  GetCategoryImageUseCase({required this.categoryRepository});

  Future<Either<Failure,Unit>> call({source = ImageSource.gallery}) {
    return categoryRepository.getCategoryImage(source: ImageSource.gallery);
  }
}
