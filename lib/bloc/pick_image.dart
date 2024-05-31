// image_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

// Image Events
abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class PickImage extends ImageEvent {
  @override
  List<Object> get props => [];
}

// Image States
abstract class ImageState extends Equatable {
  const ImageState();
}

class ImageInitial extends ImageState {
  @override
  List<Object> get props => [];
}

class ImagePicked extends ImageState {
  final File image;

  const ImagePicked(this.image);

  @override
  List<Object> get props => [image];
}

// ImageBloc
class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImagePicker imagePicker = ImagePicker();

  ImageBloc() : super(ImageInitial()) {
    on<PickImage>((event, emit) async {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        emit(ImagePicked(File(pickedImage.path)));
      }
    });
  }
}
