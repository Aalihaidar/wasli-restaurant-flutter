import 'dart:convert';

import 'package:wasli_restaurant/core/error/api_error.dart';

/// Reads the `errors` of the API's standard error body: `{"type": "...", "errors": [{"code", "detail", "attr"}]}`.
///
/// [body] is what the HTTP client handed over: usually a decoded JSON object, but a proxy or Django's own error page
/// arrives as a string or as nothing at all. Anything that is not the standard shape gives an empty list, so the
/// caller falls back to the generic failure of the HTTP status. Entries without a string `code` are skipped, and a
/// non-string `attr` counts as no field. `type` and `detail` are ignored on purpose.
List<ApiError> parseApiErrors(Object? body) {
  final json = body is String ? _tryDecode(body) : body;
  if (json is! Map<String, dynamic>) {
    return const [];
  }
  final entries = json['errors'];
  if (entries is! List<dynamic>) {
    return const [];
  }
  return [
    for (final entry in entries)
      if (entry is Map<String, dynamic> && entry['code'] is String)
        ApiError(entry['code'] as String, attr: entry['attr'] is String ? entry['attr'] as String : null),
  ];
}

Object? _tryDecode(String text) {
  try {
    return jsonDecode(text);
  } on FormatException {
    return null;
  }
}
