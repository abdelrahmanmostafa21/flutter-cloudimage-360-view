import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef _ImageNameIndexBuilder = String Function(int index);

class Ci360ImageModel {
  Ci360ImageModel.horizontal({
    required this.imageFolder,
    required this.imageName,
    required this.imagesLength,
  })  : axis = Axis.horizontal,
        assert(
          imageFolder.isNotEmpty && imagesLength > 0,
          'image folder cannot be empty, and image length must be greater than 0',
        );

  Ci360ImageModel.vertical({
    required this.imageFolder,
    required this.imageName,
    required this.imagesLength,
  })  : axis = Axis.horizontal,
        assert(
          imageFolder.isNotEmpty && imagesLength > 0,
          'image folder cannot be empty, and image length must be greater than 0',
        );

  /// Your images folder on server.
  /// Base Data Folder Url For the main image.
  /// i.e 'https://domain.com/image/nike-shoes/
  final String imageFolder;

  /// The filename pattern for your 360 image in {x|y}-Axis builder.
  /// Must include {index} in the image path
  /// which the library will replace with a number between 1 and imageLength- in axis {x|y}.
  final _ImageNameIndexBuilder imageName;

  /// Amount of images to load in {x|y}-axis for 360 view.
  /// Must Be Valid Length To Get The Valid FileName Of The Image
  final int imagesLength;

  ///Axis For Image Model [Axis.horizontal] || [Axis.vertical]
  final Axis axis;

  Ci360ImageModel copyWith({
    String? imageFolder,
    _ImageNameIndexBuilder? imageName,
    int? imagesLength,
    Axis? axis,
  }) {
    if (axis == Axis.horizontal) {
      return Ci360ImageModel.horizontal(
        imageFolder: imageFolder ?? this.imageFolder,
        imageName: imageName ?? this.imageName,
        imagesLength: imagesLength ?? this.imagesLength,
      );
    }
    return Ci360ImageModel.vertical(
      imageFolder: imageFolder ?? this.imageFolder,
      imageName: imageName ?? this.imageName,
      imagesLength: imagesLength ?? this.imagesLength,
    );
  }
}

extension Ci360ImageModelExtension on Ci360ImageModel {
  /// Get Specified Image For Index
  String imagePath(int index) => imageFolder + imageName.call(index);

  List<ImageProvider> get imageProviders {
    final providers = <ImageProvider>[];
    for (var i = 1; i <= imagesLength; i++) {
      final url = imagePath(i);
      providers.add(CachedNetworkImageProvider(url));
    }
    return providers;
  }
}
