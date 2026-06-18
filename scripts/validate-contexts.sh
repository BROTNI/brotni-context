#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMA="${REPO_ROOT}/context/lifecycle/v1/schema/context-lifecycle.v1.schema.json"
EXIT_CODE=0

# Prefer python3 jsonschema, then ajv-cli, then npx ajv-cli
if command -v python3 &>/dev/null && python3 -c "import jsonschema, yaml" 2>/dev/null; then
  VALIDATOR="python"
elif command -v ajv &>/dev/null; then
  VALIDATOR="ajv"
elif command -v npx &>/dev/null; then
  VALIDATOR="npx-ajv"
else
  echo "ERROR: No JSON Schema validator found."
  echo "Install one of:"
  echo "  pip install jsonschema pyyaml"
  echo "  npm install -g ajv-cli ajv-formats"
  exit 1
fi

validate_yaml() {
  local file="$1"
  local expect_valid="$2"
  local result

  if [ "$VALIDATOR" = "python" ]; then
    if python3 - "$file" "$SCHEMA" <<'PYEOF' 2>/dev/null
import sys, json, yaml, jsonschema

with open(sys.argv[1]) as f:
    instance = yaml.safe_load(f)
with open(sys.argv[2]) as f:
    schema = json.load(f)

try:
    jsonschema.validate(instance, schema)
    sys.exit(0)
except jsonschema.ValidationError:
    sys.exit(1)
PYEOF
    then
      result="valid"
    else
      result="invalid"
    fi
  elif [ "$VALIDATOR" = "ajv" ]; then
    if ajv validate -s "$SCHEMA" -d "$file" --spec=draft7 2>/dev/null; then
      result="valid"
    else
      result="invalid"
    fi
  elif [ "$VALIDATOR" = "npx-ajv" ]; then
    if npx --yes ajv-cli validate -s "$SCHEMA" -d "$file" --spec=draft7 2>/dev/null; then
      result="valid"
    else
      result="invalid"
    fi
  fi

  if [ "$expect_valid" = "true" ] && [ "$result" = "valid" ]; then
    echo "  PASS (valid): ${file#"$REPO_ROOT/"}"
  elif [ "$expect_valid" = "false" ] && [ "$result" = "invalid" ]; then
    echo "  PASS (correctly invalid): ${file#"$REPO_ROOT/"}"
  elif [ "$expect_valid" = "true" ] && [ "$result" = "invalid" ]; then
    echo "  FAIL (expected valid, got invalid): ${file#"$REPO_ROOT/"}"
    EXIT_CODE=1
  elif [ "$expect_valid" = "false" ] && [ "$result" = "valid" ]; then
    echo "  FAIL (expected invalid, got valid): ${file#"$REPO_ROOT/"}"
    EXIT_CODE=1
  fi
}

echo "=== Validating context examples ==="
for f in "${REPO_ROOT}"/context/lifecycle/v1/examples/**/*.yaml; do
  [ -f "$f" ] || continue
  validate_yaml "$f" "true"
done

echo ""
echo "=== Validating valid fixtures ==="
for f in "${REPO_ROOT}"/context/lifecycle/v1/tests/fixtures/valid/*.yaml; do
  [ -f "$f" ] || continue
  validate_yaml "$f" "true"
done

echo ""
echo "=== Validating invalid fixtures (should fail validation) ==="
for f in "${REPO_ROOT}"/context/lifecycle/v1/tests/fixtures/invalid/*.yaml; do
  [ -f "$f" ] || continue
  validate_yaml "$f" "false"
done

echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
  echo "All validations passed."
else
  echo "One or more validations failed."
fi

exit "$EXIT_CODE"
