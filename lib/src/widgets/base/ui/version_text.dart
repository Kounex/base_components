import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BaseVersionText extends StatefulWidget {
  final TextStyle? style;

  final bool includeBuildNumber;

  const BaseVersionText({
    super.key,
    this.style,
    this.includeBuildNumber = true,
  });

  @override
  State<BaseVersionText> createState() => _BaseVersionTextState();
}

class _BaseVersionTextState extends State<BaseVersionText> {
  late final Future<String> _version;

  @override
  void initState() {
    super.initState();

    _version = _getVersionText();
  }

  Future<String> _getVersionText() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}${this.widget.includeBuildNumber ? "+${packageInfo.buildNumber}" : ""}';
  }

  @override
  Widget build(BuildContext context) {
    final style = this.widget.style ??
        Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).disabledColor,
            );

    return BaseFutureBuilder<String>(
      future: _version,
      loading: Text(
        '-',
        style: style,
      ),
      data: (versionText) => Text(
        versionText ?? '-',
        style: style,
      ),
    );
  }
}
