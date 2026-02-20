#!/bin/bash

#GITHUB_REPO="https://github.com/ffhs/filament-package_ffhs_approvals"
#EXCLUDED_GIT_TAGS='alpha|beta|dev'
GITHUB_REPO="https://internal-git.alpen.ffhs.ch/ffhs-it-services/laravel/filament-package_ffhs_approvals.git"
EXCLUDED_GIT_TAGS='dev'


rm -rf ./temp
mkdir -p "temp"
cp -r ./docusaurus ./temp/docusaurus
cd ./temp/docusaurus
npm install

cd ../
git clone $GITHUB_REPO repo
cd ./repo

for TAG in $(git tag --list 'v*.*.*' | grep -v -E "(EXCLUDED_GIT_TAGS)"); do
    echo "Processing $TAG"
    git checkout "$TAG"
    rm -rf ../docusaurus/docs

    if [ -d "docs" ]; then
            echo "docs folder found for $TAG"

            cp -r ./docs/doc ../docusaurus/docs
            sed -i '1i\---\nsidebar_position: 1\n---\n' ../docusaurus/docs/intro.md

        else
            echo "No docs folder for $TAG, take readme"

            mkdir ../docusaurus/docs
            cp README.md ../docusaurus/docs/intro.md
            if [ -d "images" ]; then
                cp -r ./images ../docusaurus/docs/images
            fi
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

# Apply metadata from docs/metadata.json to docusaurus config
if [ -f "docs/metadata.json" ]; then
    echo "metadata.json found, applying to docusaurus config"

    META_TITLE=$(cat docs/metadata.json | python3 -c "import sys,json; print(json.load(sys.stdin).get('title',''))")
    META_TAGLINE=$(cat docs/metadata.json | python3 -c "import sys,json; print(json.load(sys.stdin).get('tagline',''))")
    META_URL=$(cat docs/metadata.json | python3 -c "import sys,json; print(json.load(sys.stdin).get('side-url',''))")
    META_PROJECT=$(cat docs/metadata.json | python3 -c "import sys,json; print(json.load(sys.stdin).get('projectName',''))")

    CONFIG="../docusaurus/docusaurus.config.js"

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

    META_HAS_INDEX=$(cat docs/metadata.json | python3 -c "import sys,json; print(json.load(sys.stdin).get('has_index_page', True))")

    if [ "$META_HAS_INDEX" = "False" ]; then
      echo "No index page requested, removing index.js to redirect to /intro"
      rm -f ../docusaurus/src/pages/index.js
      rm -f ../docusaurus/src/pages/index.module.css
    fi
else
    echo "No metadata.json found, using default config values"
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

cd ../docusaurus
npm run build
cp -r ./build ../../build

cd ../../

#rm -rf /temp
