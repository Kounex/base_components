import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/design_system.dart';
import '../../../utils/modal.dart';
import '../../dialog/confirmation.dart';
import '../functional/cached_memory_image.dart';
import 'progress_indicator.dart';

class BaseImage extends StatelessWidget {
  final String? imageBase64;
  final String? imageUuid;
  final XFile? image;

  final double? height;
  final double? width;

  final double? borderRadius;
  final double? borderWidth;

  final double actionSize;
  final IconData? icon;
  final void Function()? onAction;

  const BaseImage({
    super.key,
    this.imageBase64,
    this.imageUuid,
    this.image,
    this.height,
    this.width,
    this.borderRadius,
    this.borderWidth,
    this.actionSize = 32.0,
    this.icon,
    this.onAction,
  }) : assert(imageBase64 != null || imageUuid != null || image != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: this.height,
          width: this.width,
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: this.borderWidth ?? DesignSystem.border.width3,
            ),
            borderRadius: BorderRadius.circular(
                this.borderRadius ?? DesignSystem.border.radius12),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  this.borderRadius ?? DesignSystem.border.radius12),
              child: () {
                if (this.imageBase64 != null) {
                  return BaseCachedMemoryImage(
                    imageBase64: this.imageBase64!,
                    height: this.height,
                    width: this.width,
                  );
                }
                if (this.image != null) {
                  return FutureBuilder<Uint8List>(
                    future: this.image!.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return BaseCachedMemoryImage(
                            imageBase64: base64Encode(snapshot.data!),
                            height: this.height,
                            width: this.width,
                          );
                        }
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BaseProgressIndicator();
                      }
                      return const SizedBox();
                    },
                  );
                }
                if (this.imageUuid != null) {
                  return FutureBuilder<Directory>(
                    future: getApplicationDocumentsDirectory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Image(
                            image: FileImage(
                              File('${snapshot.data!.path}/${this.imageUuid}'),
                            ),
                            height: this.height,
                            width: this.width,
                            fit: BoxFit.cover,
                          );
                        }
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return BaseProgressIndicator();
                      }
                      return const SizedBox();
                    },
                  );
                }
              }()),
        ),
        if (this.icon != null && this.onAction != null)
          GestureDetector(
            onTap: () => ModalUtils.showBaseDialog(
              context,
              BaseConfirmationDialog(
                title: 'Delete Image',
                body: 'Are you sure you want to delete this image?',
                onYes: (_) => this.onAction,
                isYesDestructive: true,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              height: this.actionSize,
              width: this.actionSize,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      this.borderRadius ?? DesignSystem.border.radius12),
                  topRight: Radius.circular(
                      this.borderRadius ?? DesignSystem.border.radius12),
                ),
              ),
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(DesignSystem.spacing.x8),
                child: Icon(
                  this.icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )),
            ),
          ),
      ],
    );
  }
}
