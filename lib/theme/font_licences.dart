import 'package:flutter/foundation.dart' show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/services.dart' show rootBundle;

/// The asset that holds the licence text of Rubik (SIL Open Font License 1.1).
const String rubikLicenceAsset = 'assets/fonts/Rubik-OFL.txt';

/// Adds the licence of the bundled font to the licence page (`showLicensePage`), as the licence requires.
///
/// The text is read from the asset only when the page is opened.
void registerFontLicences() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Rubik'], await rootBundle.loadString(rubikLicenceAsset));
  });
}
