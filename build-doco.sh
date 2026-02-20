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
    rm ../docusaurus/static/img/logo.png
    cp ./docs/favicon.ico ../docusaurus/static/img/favicon.ico
fi



cd ../docusaurus
npm run build
cp -r ./build ../../build

cd ../../

#rm -rf /temp
