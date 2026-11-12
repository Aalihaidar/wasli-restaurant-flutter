#!/usr/bin/env bash
# Checks the folder rules of the app and lists every violation. Run it from anywhere; it exits 1 on a violation.
#
#   core, theme, api   never import features/ or app/
#   domain/            pure Dart: no Flutter, Dio, Riverpod, generated client or other layers of the feature
#   features           never import another feature's data/ or presentation/
#   api/               only a feature's data/ layer imports the generated client
#   dart:io, dart:html only in lib/core/platform (everything else goes through the platform interfaces)
#
# Only package imports are checked. Inside a feature, relative imports stay within the feature.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

pkg='package:wasli_restaurant'
failed=0

# scan <title> <pattern> <ignore> <path>...
# Prints every Dart line under the existing paths that matches <pattern> (grep -P) and not <ignore> (empty = none).
scan() {
  local title="$1" pattern="$2" ignore="$3"
  shift 3
  local -a paths=()
  local path
  for path in "$@"; do
    if [[ -e "$path" ]]; then
      paths+=("$path")
    fi
  done
  if ((${#paths[@]} == 0)); then
    return 0
  fi
  local hits
  hits="$(grep -rnP --include='*.dart' -e "$pattern" "${paths[@]}" || true)"
  if [[ -n "$ignore" && -n "$hits" ]]; then
    hits="$(printf '%s\n' "$hits" | grep -vP -e "$ignore" || true)"
  fi
  if [[ -n "$hits" ]]; then
    printf 'FAIL: %s\n%s\n\n' "$title" "$hits" >&2
    failed=1
  fi
}

scan 'core, theme and api must not import features/ or app/' \
  "^import '$pkg/(features|app)/" '' \
  lib/core lib/theme lib/api

mapfile -t domain_dirs < <(find lib/features -type d -name domain 2>/dev/null || true)
scan 'domain must be pure Dart (no Flutter, Dio, Riverpod, api, app or other layers)' \
  "^import '(package:(flutter|flutter_riverpod|flutter_web_plugins|dio|retrofit|json_annotation)/|$pkg/(api|app)/|$pkg/features/[^/]+/(data|application|presentation)/)" '' \
  "${domain_dirs[@]}"

for feature_dir in lib/features/*/; do
  if [[ ! -d "$feature_dir" ]]; then
    continue
  fi
  name="$(basename "$feature_dir")"
  scan "feature '$name' imports another feature's data/ or presentation/" \
    "^import '$pkg/features/(?!$name/)[^/]+/(data|presentation)/" '' \
    "$feature_dir"
done

scan "only a feature's data/ layer may import the generated client" \
  "^import '$pkg/api/" '^lib/(api|features/[^/]+/data)/' \
  lib

scan 'dart:io and dart:html belong in lib/core/platform only' \
  "^import 'dart:(io|html)'" '^lib/(core/platform|api)/' \
  lib

if ((failed)); then
  exit 1
fi
echo 'Folder boundaries: OK'
