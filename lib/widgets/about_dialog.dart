import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

void aboutDialog(BuildContext context, String appName, String version) {
  showAboutDialog(
    context: context,
    //applicationIcon: ,
    applicationLegalese: 'Copyright ©️ 2021 flognity (Florian Wilhelm)',
    applicationName: appName,
    applicationVersion: version,
    children: [
      const SizedBox(height: 20.0),
      const Text(
        'This app was developed and designed by flognity (Florian Wilhelm).',
      ),
      const SizedBox(height: 10.0),
      const Text('For more information, visit:'),
      Link(
        uri: Uri.parse('https://flognity.com'),
        target: LinkTarget.blank,
        builder: (ctx, openLink) => Wrap(
          alignment: WrapAlignment.start,
          children: [
            TextButton(
              onPressed: openLink,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: const Text('https://flognity.com'),
            ),
          ],
        ),
      ),
    ],
  );
}
