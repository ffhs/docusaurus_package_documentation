#!/bin/bash

# Check if repo URL is provided as argument
if [ -z "$1" ]; then
    echo "Usage: $0 <git-repo-url>"
    echo "Example: $0 https://internal-git.alpen.ffhs.ch/ffhs-it-services/laravel/filament-package_ffhs_approvals.git"
    exit 1
fi

GITHUB_REPO="$1"

echo "Building documentation for: $GITHUB_REPO"


rm -rf ./temp
mkdir -p "temp"
cp -r ./docusaurus ./temp/docusaurus
cd ./temp/docusaurus
npm install

cd ../
git clone $GITHUB_REPO repo
cd ./repo

# Apply metadata from docs/metadata.json to docusaurus config
if [ -f "docs/metadata.json" ]; then
        echo "Applying metadata.json configuration"

        META_TITLE=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('title',''))")
        META_TAGLINE=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tagline',''))")
        META_SIDE_URL=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('side_url',''))")
        META_BASE_URL=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('base_url',''))")
        META_PROJECT=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('project_name',''))")
        META_GITHUB_URL=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('github_url',''))")

        CONFIG="../docusaurus/docusaurus.config.js"

        if [ -n "$META_TITLE" ]; then
            sed -i.bak "s|title: '[^']*'|title: '$META_TITLE'|g" "$CONFIG" && rm -f "$CONFIG.bak"
            echo "✓ Updated title: $META_TITLE"
        fi
        if [ -n "$META_TAGLINE" ]; then
            sed -i.bak "s|tagline: '[^']*'|tagline: '$META_TAGLINE'|g" "$CONFIG" && rm -f "$CONFIG.bak"
            echo "✓ Updated tagline: $META_TAGLINE"
        fi
        if [ -n "$META_SIDE_URL" ]; then
            sed -i.bak "s|url: '[^']*'|url: '$META_SIDE_URL'|g" "$CONFIG" && rm -f "$CONFIG.bak"
            echo "✓ Updated SIDE URL: $META_SIDE_URL"
        fi
        if [ -n "$META_BASE_URL" ]; then
            sed -i.bak "s|baseUrl: '[^']*'|baseUrl: '$META_BASE_URL'|g" "$CONFIG" && rm -f "$CONFIG.bak"
            echo "✓ Updated BASE URL: $META_BASE_URL"
        fi
        if [ -n "$META_PROJECT" ]; then
            sed -i.bak "s|projectName: '[^']*'|projectName: '$META_PROJECT'|g" "$CONFIG" && rm -f "$CONFIG.bak"
            echo "✓ Updated project name: $META_PROJECT"
        fi
        if [ -n "$META_GITHUB_URL" ]; then
                sed -i.bak "s|href: 'https://github.com/[^']*'|href: '$META_GITHUB_URL'|g" "$CONFIG" && rm -f "$CONFIG.bak"
                echo "✓ Updated GitHub URL: $META_GITHUB_URL"
        fi

        # Handle index page redirect
        META_HAS_INDEX=$(cat "docs/metadata.json" | python3 -c "import sys,json; print(json.load(sys.stdin).get('has_index_page', True))")

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
        FEATURES=$(cat "docs/metadata.json" | python3 -c "
    import sys, json
    data = json.load(sys.stdin)
    features = data.get('features', [])
    if features:
        print(json.dumps(features, indent=4))
    ")
        if [ -n "$FEATURES" ]; then
            echo "Applying homepage features"
            echo "$FEATURES" > ./src/components/HomepageFeatures/features.json
            echo "✓ Features updated"
        fi
    else
        echo "No metadata.json found, using defaults"
    fi

# Get the highest patch for each major.minor, preferring stable over pre-release
TAGS=$(git tag --list 'v*.*.*' | sort -V | awk -F'[v.-]' '
{
    tag = $0
    major = $2
    minor = $3
    # Extract patch number (remove any alpha/beta/dev suffix)
    gsub(/-.*/,"",$4)
    patch = $4
    key = major "." minor
    is_prerelease = (tag ~ /-(alpha|beta|dev)/)

    # Store tag: prefer stable, or keep prerelease if no stable exists yet
    if (!is_prerelease) {
        stable[key] = tag
    } else if (!(key in stable)) {
        prerelease[key] = tag
    }
}
END {
    for (key in stable) print stable[key]
    for (key in prerelease) if (!(key in stable)) print prerelease[key]
}' | sort -V)

# Find the newest stable version (highest version without alpha/beta/dev)
NEWEST_STABLE=$(echo "$TAGS" | grep -v -E "(alpha|beta|dev)" | sort -V | tail -n 1)
NEWEST_STABLE_VERSION="${NEWEST_STABLE#v}"  # Remove 'v' prefix

echo "Newest stable version: $NEWEST_STABLE_VERSION"


for TAG in $TAGS; do
    echo "Processing $TAG"
    git checkout "$TAG"
    rm -rf ../docusaurus/docs

    if [ -d "docs" ]; then
            echo "docs folder found for $TAG"

            cp -r ./docs/doc ../docusaurus/docs

    else
                echo "No docs folder for $TAG, take readme"

                mkdir ../docusaurus/docs
                cp README.md ../docusaurus/docs/intro.md
                sed -i '1i\---\nsidebar_position: 1\n---\n' ../docusaurus/docs/intro.md
                if [ -d "images" ]; then
                    cp -r ./images ../docusaurus/docs/images
                fi

                # Rewrite local .md links to point to the GitLab repo
                REPO_BROWSE_URL="${GITHUB_REPO%.git}/-/blob/${TAG}"
                sed -i "s|(LICENSE\.md)|(${REPO_BROWSE_URL}/LICENSE.md)|g" ../docusaurus/docs/intro.md
                sed -i "s|(LICENSE)|(${REPO_BROWSE_URL}/LICENSE)|g" ../docusaurus/docs/intro.md
                sed -i "s|(CHANGELOG\.md)|(${REPO_BROWSE_URL}/CHANGELOG.md)|g" ../docusaurus/docs/intro.md
                sed -i "s|(\.github/CONTRIBUTING\.md)|(${REPO_BROWSE_URL}/.github/CONTRIBUTING.md)|g" ../docusaurus/docs/intro.md
                sed -i "s|\.\./\.\./security/policy|${GITHUB_REPO%.git}/-/security/policy|g" ../docusaurus/docs/intro.md
                sed -i '1i\---\nsidebar_position: 1\n---\n' ../docusaurus/docs/intro.md
    fi

    cd ../docusaurus
    npm run docusaurus docs:version "${TAG#v}"
    cd ../repo

done

git checkout HEAD

if [ -f "docs/logo.png" ]; then
    rm ../docusaurus/static/img/logo.png
    cp ./docs/logo.png ../docusaurus/static/img/logo.png
fi

if [ -f "docs/favicon.ico" ]; then
    rm ../docusaurus/static/img/favicon.ico
    cp ./docs/favicon.ico ../docusaurus/static/img/favicon.ico
fi

if [ -f "docs/features" ]; then
    rm -rf ../docusaurus/static/img/features
    cp  -rf ./docs/features ../docusaurus/static/img/features
fi

# Features
if [ -f "docs/metadata.json" ]; then
    FEATURES=$(cat docs/metadata.json | python3 -c "
import sys, json
data = json.load(sys.stdin)
features = data.get('features', [])
if features:
    print(json.dumps(features, indent=4))
")
    if [ -n "$FEATURES" ]; then
        rm ../docusaurus/src/components/HomepageFeatures/features.json
        echo "$FEATURES" > ../docusaurus/src/components/HomepageFeatures/features.json
        echo "Features extracted to features.json"
    fi
fi

if [ -d "docs/features" ]; then
    rm -rf ../docusaurus/static/img/features
    cp -rf ./docs/features ../docusaurus/static/img/features
fi

# Update docusaurus.config.js with the newest stable version as current
if [ -n "$NEWEST_STABLE_VERSION" ]; then
    CONFIG="../docusaurus/docusaurus.config.js"
    echo "Setting current version to: $NEWEST_STABLE_VERSION"

    # Use Node.js to properly update the config
    node -e "
const fs = require('fs');
const configPath = '$CONFIG';
let content = fs.readFileSync(configPath, 'utf8');

// Find the docs config and add version settings
const versionConfig = \`docs: {
          sidebarPath: './sidebars.js',
          routeBasePath: '/',
          lastVersion: '$NEWEST_STABLE_VERSION',
          versions: {
            current: {
              label: 'Unreleased',
              path: 'next',
              banner: 'unreleased',
            },
          },
          onlyIncludeVersions: (() => {
            try {
              const versions = require('./versions.json');
              return versions; // Exclude 'current', only show versioned docs
            } catch { return undefined; }
          })(),\`;

content = content.replace(/docs:\s*\{[^}]*sidebarPath:[^,]*,[^}]*routeBasePath:[^,]*,/s, versionConfig);

fs.writeFileSync(configPath, content);
console.log('Updated docusaurus.config.js with current version: $NEWEST_STABLE_VERSION');
"
fi

cd ../docusaurus
npm run build
cp -r ./build ../../build

cd ../../
#rm -rf /temp
