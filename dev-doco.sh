#!/bin/bash

# dev-doco.sh - Development mode for documentation

# Check if docs path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-docs-folder>"
    echo "Example: $0 /path/to/your-repo/docs"
    exit 1
fi

# Convert to absolute path BEFORE changing directories
DOCS_PATH="$(cd "$1" && pwd)"

# Validate the path exists
if [ ! -d "$DOCS_PATH" ]; then
    echo "Error: Directory '$1' does not exist"
    exit 1
fi

echo "Starting dev mode for: $DOCS_PATH"

# Clean up and prepare
rm -rf ./temp
mkdir -p "temp"
cp -r ./docusaurus ./temp/docusaurus
cd ./temp/docusaurus
npm install

# Copy documentation content
rm -rf ./docs
if [ -d "$DOCS_PATH/doc" ]; then
    echo "Copying docs from $DOCS_PATH/doc"
    cp -r "$DOCS_PATH/doc" ./docs
else
    echo "Error: No 'doc' subfolder found in $DOCS_PATH"
    echo "Expected structure: $DOCS_PATH/doc/intro.md"
    exit 1
fi

# Copy logo if exists
if [ -f "$DOCS_PATH/logo.png" ]; then
    echo "Copying custom logo"
    rm -f ./static/img/logo.png
    cp "$DOCS_PATH/logo.png" ./static/img/logo.png
fi

# Copy favicon if exists
if [ -f "$DOCS_PATH/favicon.ico" ]; then
    echo "Copying custom favicon"
    rm -f ./static/img/favicon.ico
    cp "$DOCS_PATH/favicon.ico" ./static/img/favicon.ico
fi

# Apply metadata configuration
if [ -f "$DOCS_PATH/metadata.json" ]; then
    echo "Applying metadata.json configuration"

    META_TITLE=$(cat "$DOCS_PATH/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('title',''))")
    META_TAGLINE=$(cat "$DOCS_PATH/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tagline',''))")
    META_URL=$(cat "$DOCS_PATH/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('side-url',''))")
    META_PROJECT=$(cat "$DOCS_PATH/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('projectName',''))")

    CONFIG="./docusaurus.config.js"

    if [ -n "$META_TITLE" ]; then
        sed -i "s|title: '.*'|title: '$META_TITLE'|" "$CONFIG"
    fi
    if [ -n "$META_TAGLINE" ]; then
        sed -i "s|tagline: '.*'|tagline: '$META_TAGLINE'|" "$CONFIG"
    fi
    if [ -n "$META_URL" ]; then
        sed -i "s|url: '.*'|url: '$META_URL'|" "$CONFIG"
    fi
    if [ -n "$META_PROJECT" ]; then
        sed -i "s|projectName: '.*'|projectName: '$META_PROJECT'|" "$CONFIG"
    fi

    # Handle index page redirect
    META_HAS_INDEX=$(cat "$DOCS_PATH/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('has_index_page', True))")

    if [ "$META_HAS_INDEX" = "False" ]; then
        echo "Configuring redirect to /intro"
        rm -f ./src/pages/index.module.css
        cat > ./src/pages/index.js << 'EOF'
import {Redirect} from '@docusaurus/router';

export default function Home() {
  return <Redirect to="/intro" />;
}
EOF
    fi

    # Extract and apply features
    FEATURES=$(cat "$DOCS_PATH/metadata.json" | python3 -c "
import sys, json
data = json.load(sys.stdin)
features = data.get('features', [])
if features:
    print(json.dumps(features, indent=4))
")
    if [ -n "$FEATURES" ]; then
        echo "Applying homepage features"
        echo "$FEATURES" > ./src/components/HomepageFeatures/features.json
    fi
else
    echo "No metadata.json found, using defaults"
fi

# Copy feature images
if [ -d "$DOCS_PATH/features" ]; then
    echo "Copying feature images"
    rm -rf ./static/img/features
    cp -rf "$DOCS_PATH/features" ./static/img/features
fi

# Remove version dropdown from navbar (no versions in dev mode)
node -e "
const fs = require('fs');
let content = fs.readFileSync('./docusaurus.config.js', 'utf8');
content = content.replace(/\{\s*type:\s*'docsVersionDropdown'[^}]*\},?/g, '');
fs.writeFileSync('./docusaurus.config.js', content);
console.log('Removed version dropdown for dev mode');
"

echo ""
echo "=========================================="
echo "  Dev server starting..."
echo "  Changes in $DOCS_PATH/doc will require restart"
echo "=========================================="
echo ""

# Start development server
npm run start
