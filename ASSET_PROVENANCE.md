# Asset Provenance and Rights Scope

## Inventory

`ASSET_MANIFEST.sha256` is the authoritative V1.0 inventory of distributable binary and visual assets. Each row records:

1. SHA-256 hash;
2. file size in bytes; and
3. path relative to the `DragonflightUI` directory.

The manifest is generated from the final installed tree immediately before packaging.

## Provenance result

The visual assets supplied for DragonflightUI_Luna were compared with Dragonflight UI Classic `v0.40.3`, commit `b8b35451d4621a8097e887385f72ec03e17765f1`.

- Originally supplied visual assets: 280
- Byte-identical to the probable upstream commit: 280
- Original DragonflightUI_Luna branded textures identified: 1
- AI-generated or AI-edited branded textures identified: 1
- Removed for DragonflightUI_Luna V1.0: `Textures/Art/coffee.tga`

The transparent V1.0 project avatar is bundled as `Textures/Art/luna-logo.tga` and displayed as a non-interactive image in the upper-left corner of the screen while Edit Mode is active. The supplied RGBA artwork was resized to a WoW-compatible 512-by-512 TGA without changing its design.

## Rights classification

The remaining gameplay textures are classified as **inherited upstream content with per-asset origin and redistribution rights not independently verified**.

This classification is intentionally narrower than “MIT-licensed asset.” The upstream root uses the MIT License, but the supplied repository does not document, asset by asset, whether each BLP/TGA file was:

- created by an upstream contributor;
- exported or adapted from the World of Warcraft client;
- obtained from another addon or third party; or
- distributed under a separate permission.

Many filenames use Blizzard interface terminology such as `UI-HUD`, `UIActionbar`, `uimicromenu`, `uiminimap`, profession backgrounds, unit frames, and group-finder artwork. That is a reason for manual review, not proof of a particular asset's legal origin.

## DragonflightUI_Luna claims

DragonflightUI_Luna does not claim:

- authorship of inherited upstream textures;
- ownership of Blizzard or third-party artwork;
- that Blizzard trademarks or game assets are covered by DragonflightUI_Luna's MIT notice; or
- trademark clearance for the project name.

The files remain in the package because they are part of the inherited interface implementation and removing them wholesale would break the addon.

## Separate project avatar

The Luna project avatar was generated with OpenAI image generation on 24 July 2026 from a new prompt requesting a silver-white crescent moon and four-point star on a navy background.

No source image was supplied to the generator. The prompt expressly prohibited World of Warcraft and Blizzard logos, Warcraft lettering, official UI frames, characters, screenshots, faction symbols, and third-party brand marks.

The image should be disclosed as AI-generated on the project page. Image-generation disclosure does not itself guarantee uniqueness or trademark clearance.

## Manual check still recommended

Before public distribution, the safest remaining step is written confirmation from the Dragonflight UI Classic maintainer that the inherited texture bundle may be redistributed in a separately branded fork, or an asset-by-asset replacement with original or independently licensed artwork.

This file is not legal advice or a guarantee of rights clearance.
