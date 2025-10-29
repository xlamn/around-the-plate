import 'package:app_theme/app_theme.dart';
import 'package:directory_image_storage_api/directory_image_storage_api.dart';
import 'package:flutter/material.dart';

import '../../../image_picker/service/image_picker_service.dart';

class DishFormImage extends StatelessWidget {
  final imagePickerService = ImagePickerService.instance;
  final imageStorageApi = DirectoryImageStorageApi.instance;

  final ImagePathController<String> controller;

  const DishFormImage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: controller,
      builder: (context, path, _) {
        final file = imageStorageApi.getImageFile(path ?? '');

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: file != null
                  ? Image.file(
                      file,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(
                      width: 120,
                      height: 120,
                      child: Icon(FIcons.imageOff),
                    ),
            ),
            Positioned(
              bottom: -8,
              right: -8,
              child: GestureDetector(
                onTap: () async {
                  final imagePath = await imagePickerService.pickImage(context);
                  if (imagePath == null) return;
                  controller.path = imagePath;
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: context.theme.colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.theme.colors.primaryForeground,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    FIcons.pencil,
                    color: context.theme.colors.primaryForeground,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ImagePathController<T> extends ValueNotifier<T?> {
  ImagePathController([super.initialPath]);

  T? get path => value;

  set path(T? newPath) {
    if (newPath != value) {
      value = newPath;
    }
  }

  void clear() => value = null;
}
