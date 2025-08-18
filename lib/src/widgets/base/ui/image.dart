import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:base_components/src/widgets/base/ui/placeholder_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/design_system.dart';
import '../../../utils/modal.dart';
import '../../dialog/confirmation.dart';
import '../functional/cached_memory_image.dart';
import 'progress_indicator.dart';

class BaseImage extends StatefulWidget {
  final String? imageBase64;
  final XFile? image;

  /// Used as the name on the file system and matched with:
  /// [basePath]/[subPath]/[imageUuid]
  final String? imageUuid;

  /// If for whatever reason the base path should be something else than
  /// [getApplicationDocumentsDirectory()], we can define it here explicitly
  final String? basePath;

  /// By default it's looking on the root of [basePath], with subPath it's
  /// looking for the path inside it
  final String? subPath;

  final double? height;
  final double? width;

  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;

  final double actionSize;
  final IconData? icon;
  final void Function()? onAction;

  final IconData? additionalIcon;
  final double additionalIconSize;

  const BaseImage({
    super.key,
    this.imageBase64,
    this.image,
    this.imageUuid,
    this.basePath,
    this.subPath,
    this.height,
    this.width,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.actionSize = 32.0,
    this.icon,
    this.onAction,
    this.additionalIcon,
    this.additionalIconSize = 32.0,
  }) : assert(imageBase64 != null || imageUuid != null || image != null);

  @override
  State<BaseImage> createState() => _BaseImageState();
}

class _BaseImageState extends State<BaseImage> {
  late final Future<Uint8List>? _image;
  late final Future<Directory>? _dir;

  @override
  void initState() {
    super.initState();

    if (this.widget.image != null) {
      _image = this.widget.image!.readAsBytes();
    }

    if (this.widget.imageUuid != null) {
      _dir = getApplicationDocumentsDirectory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: this.widget.height,
          width: this.widget.width,
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: this.widget.borderColor ??
                  Theme.of(context).colorScheme.primaryContainer,
              width: this.widget.borderWidth ?? DesignSystem.border.width3,
            ),
            borderRadius: BorderRadius.circular(
                this.widget.borderRadius ?? DesignSystem.border.radius12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                this.widget.borderRadius ?? DesignSystem.border.radius12),
            child: switch (true) {
              _ when this.widget.imageBase64 != null => BaseCachedMemoryImage(
                  key: ValueKey(this.widget.imageBase64),
                  imageBase64: this.widget.imageBase64!,
                  height: this.widget.height,
                  width: this.widget.width,
                ),
              _ when this.widget.image != null => FutureBuilder<Uint8List>(
                  key: ValueKey(_image),
                  future: _image,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return BaseCachedMemoryImage(
                          key: ValueKey(this.widget.image),
                          imageBase64: base64Encode(snapshot.data!),
                          height: this.widget.height,
                          width: this.widget.width,
                        );
                      }
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return BaseProgressIndicator();
                    }
                    return const SizedBox();
                  },
                ),
              _ when this.widget.imageUuid != null => FutureBuilder<Directory>(
                  key: ValueKey(_dir),
                  future: _dir,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        String? basePath;
                        String? subPath;

                        if (this.widget.basePath != null) {
                          basePath = this.widget.basePath!.endsWith('/')
                              ? this.widget.basePath!.substring(
                                  0, this.widget.basePath!.length - 1)
                              : this.widget.basePath;
                        }

                        if (this.widget.subPath != null) {
                          subPath = this.widget.subPath!.endsWith('/')
                              ? this
                                  .widget
                                  .subPath!
                                  .substring(0, this.widget.subPath!.length - 1)
                              : this.widget.subPath;
                        }

                        return Image(
                          key: ValueKey(this.widget.imageUuid),
                          image: FileImage(
                            File(
                                '${(basePath ?? snapshot.data!.path)}/${(subPath != null ? '$subPath/' : '')}${this.widget.imageUuid}'),
                          ),
                          height: this.widget.height,
                          width: this.widget.width,
                          fit: BoxFit.cover,
                        );
                      }
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return BaseProgressIndicator();
                    }
                    return const SizedBox();
                  },
                ),
              _ => const BasePlaceholder(text: 'Missing image'),
            },
          ),
        ),
        if (this.widget.icon != null && this.widget.onAction != null)
          GestureDetector(
            onTap: () => ModalUtils.showBaseDialog(
              context,
              BaseConfirmationDialog(
                title: 'Delete Image',
                body: 'Are you sure you want to delete this image?',
                onYes: (_) => this.widget.onAction?.call(),
                isYesDestructive: true,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              height: this.widget.actionSize,
              width: this.widget.actionSize,
              decoration: BoxDecoration(
                color: this.widget.borderColor ??
                    Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      this.widget.borderRadius ?? DesignSystem.border.radius12),
                  topRight: Radius.circular(
                      this.widget.borderRadius ?? DesignSystem.border.radius12),
                ),
              ),
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(DesignSystem.spacing.x8),
                  child: Icon(
                    this.widget.icon,
                    color: this.widget.borderColor != null
                        ? DesignSystem.surroundingAwareAccent(
                            surroundingColor: this.widget.borderColor)
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        if (this.widget.additionalIcon != null)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              alignment: Alignment.center,
              height: this.widget.additionalIconSize,
              width: this.widget.additionalIconSize,
              decoration: BoxDecoration(
                color: this.widget.borderColor ??
                    Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                      this.widget.borderRadius ?? DesignSystem.border.radius12),
                  topRight: Radius.circular(
                      this.widget.borderRadius ?? DesignSystem.border.radius12),
                ),
              ),
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(DesignSystem.spacing.x8),
                  child: Icon(
                    this.widget.additionalIcon,
                    color: this.widget.borderColor != null
                        ? DesignSystem.surroundingAwareAccent(
                            surroundingColor: this.widget.borderColor)
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
