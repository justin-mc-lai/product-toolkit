#!/bin/bash
# Product Toolkit Version Management
# Usage: ./version.sh <version> <command>

VERSION=$1
COMMAND=$2

case $COMMAND in
  "new")
    echo "Creating new version $VERSION"
    mkdir -p "docs/product/$VERSION"/{prd,user-story,design/wireframe,design/spec,qa/test-cases,tech/api,tech/data-model}
    echo "Created: docs/product/$VERSION/"
    ;;
  "list")
    echo "=== Version History ==="
    cat product-toolkit/config/versions.yaml
    ;;
  "current")
    echo "Current version:"
    grep "current_version" product-toolkit/config/versions.yaml | cut -d'"' -f2
    ;;
  *)
    echo "Usage: $0 <version> <command>"
    echo ""
    echo "Commands:"
    echo "  new <version>  - Create new version directory"
    echo "  list           - Show version history"
    echo "  current        - Show current version"
    ;;
esac
