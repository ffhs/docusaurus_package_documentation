# Docusaurus Documentation Generator in FFHS style

Automatically generates versioned [Docusaurus](https://docusaurus.io/) documentation websites from Git repositories.

## Features

- 📦 **Automatic versioning** – Creates docs for each tagged release
- 🏷️ **Smart version selection** – Picks the highest patch for each minor version
- 🔄 **Pre-release support** – Includes alpha/beta versions when no stable exists
- 🎨 **Customizable** – Supports custom logos, favicons, and metadata
- 🏠 **Homepage features** – Configure feature cards via `metadata.json`

## Prerequisites

- Node.js (v18 or higher)
- npm
- Git
- Python 3 (for metadata parsing)
- Bash shell

## Usage

```bash
./build-doco.sh <git-repo-url>
```

## Development Mode

For writing and previewing documentation locally without version generation:

```shell
bash ./dev-doco.sh /path/to/your-repo/doc
```

This starts a live development server at `http://localhost:3000` with hot reloading.

**Note:** Changes to markdown files are reflected immediately. Changes to `metadata.json` require a restart.

## Configuration

To customize your documentation site, create a docs/ folder on the default branch of your target repository.

### Folder Structure

```
your-repo/
├── docs/
│   ├── doc/                  # Your documentation content
│   │   ├── intro.md          # Main entry point
│   │   └── ...               # Additional documentation pages
│   ├── features/             # Feature images for homepage (SVG recommended)
│   │   ├── easy-to-use.svg
│   │   └── ...
│   ├── metadata.json         # Site configuration
│   ├── logo.png              # Custom logo for navbar
│   └── favicon.ico           # Custom favicon
└── README.md
```

### metadata.json

Configure your documentation site with a file: `metadata.json`

```json
{
    "title": "FFHS Approvals",
    "tagline": "Approve your stuff",
    "side_url": "https://your-docusaurus-site.example.com",
    "base_url": "filament-package_ffhs_approvals",
  "github_url": "https://github.com/ffhs/filament-package_ffhs_approvals",
    "project_name": "FFHS Approvals",
    "has_index_page": true,
    "features": [
        {
            "title": "Easy to Use",
            "description": "Get started quickly with minimal configuration.",
            "image": "easy-to-use.svg"
        },
        {
            "title": "Translated",
            "description": "Multi-language support out of the box.",
            "image": "translation.svg"
        }
    ]
}
```

#### Configuration Options

| Field            | Description                                                       |
|------------------|-------------------------------------------------------------------|
| `title`          | Site title displayed in the navbar and browser tab                |
| `tagline`        | Subtitle shown on the homepage                                    |
| `side-url`       | Production URL where the documentation will be hosted             |
| `projectName`    | Project name identifier                                           |
| `has_index_page` | Set to false to skip the homepage and redirect directly to /intro |
| `features`       | Array of feature cards displayed on the homepage                  |

## Fallback Behavior

If no docs/ folder exists for a tagged version, the README.md will be used as the documentation content.

## Version Selection

The script automatically selects versions based on Git tags (v*.*.*):

- Selects the highest patch version for each major.minor release
- Includes pre-release versions (alpha/beta/dev) only when no stable version exists

| Available Tags               | Selected     |
|------------------------------|--------------|
| `v1.0.0`, `v1.0.1`, `v1.0.2` | v1.0.2       |
| `v2.0.0-alpha` (no stable)   | v2.0.0-alpha |

## Output

After running the script, the static site is available in the ./build directory, ready for deployment to any static
hosting service.

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
