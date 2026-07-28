# Third-Party Notices

This distribution contains code and assets that were not created for DragonflightUI_Luna. The root MIT License applies to Dragonflight UI Classic project code and to DragonflightUI_Luna modifications only; it does not replace the licenses, permissions, or notices listed below.

All existing third-party notices and license files are retained in place. This document summarizes them without modifying their terms.

## Upstream project

| Component | Source and version evidence | License and notice |
| --- | --- | --- |
| Dragonflight UI Classic | <https://github.com/Karl-HeinzSchneider/WoW-DragonflightUI>; probable base `v0.40.3`, commit [`b8b35451d4621a8097e887385f72ec03e17765f1`](https://github.com/Karl-HeinzSchneider/WoW-DragonflightUI/commit/b8b35451d4621a8097e887385f72ec03e17765f1); original project: <https://www.curseforge.com/wow/addons/dragonflight-ui-classic> | MIT License. Preserve `Copyright (c) 2022 Karl-HeinzSchneider` and the complete root `LICENSE`. |

The supplied DragonflightUI_Luna archive had no `.git` directory. The exact acquisition route and original fork commit cannot therefore be proven from local history. The base above is marked **probable**, not certain: 576 local files matched that commit after line-ending normalization, and all 280 originally supplied visual assets matched it byte-for-byte.

## Bundled libraries and copied code

| Component and bundled location | Version or embedded marker | Source | License / redistribution evidence retained |
| --- | --- | --- | --- |
| Ace3 libraries and CallbackHandler under `Libs/` | Individual embedded library minor revisions | <https://www.wowace.com/> | Ace3-style BSD license and `Copyright (c) 2007, Ace3 Development Team` in `Libs/LICENSE.txt`. That file must remain unchanged. |
| ChatThrottleLib, `Libs/AceComm-3.0/ChatThrottleLib.lua` | Embedded with AceComm | Header in bundled file | Public-domain dedication is retained in the source header. |
| LibStub, including duplicate embedded copies | Minor `2` | <https://www.wowace.com/projects/libstub> | Public-domain dedication and author credits are retained in each bundled source file and TOC. |
| LibDeflate, `Libs/LibDeflate/` | `1.0.2-release`, library minor `3` | <https://github.com/SafeteeWoW/LibDeflate> | `LibDeflate.lua` contains the zlib notice and `Copyright (c) 2018-2020 Haoqian He`. The bundled directory also contains LGPL-3.0-or-later notices in `LICENSE.txt`, examples, and generated documentation; those notices are retained and apply to the files that state them. `docs/ldoc.css` retains its Yahoo BSD notice. |
| LibDataBroker-1.1, `Libs/LibDataBroker-1.1/` | Library minor `4`, corresponding to the historical `v1.1.4` line | <https://www.curseforge.com/wow/addons/libdatabroker-1-1/source> | The project page identifies tekkub and currently labels the project All Rights Reserved, but it also expressly instructs addon authors to hard-embed LibDataBroker. DragonflightUI_Luna retains an unmodified embedded copy and does not claim it as MIT-owned DragonflightUI_Luna code. |
| LibDBIcon-1.0, `Libs/LibDBIcon-1.0/` | Library minor `52` | <https://www.curseforge.com/wow/addons/libdbicon-1-0> | CurseForge identifies the license as Ace3 Style BSD and the current maintainer as Funkeh. The embedded source and project-slug marker are retained. |
| LibEditModeOverride, `Libs/LibEditModeOverride/` | Library minor `10` | <https://github.com/plusmouse/LibEditModeOverride> | MIT License; `Copyright (c) 2022 plusmouse`. The complete bundled `LICENSE` remains in place. |
| LibQuestXP, `Libs/LibQuestXP/` | `LibQuestXP-4.0`, minor `15` | <https://github.com/MrFox42/libquestxp>; <https://www.curseforge.com/wow/addons/libquestxp-classic> | CurseForge identifies the library as MIT-licensed and MisterFox9 as owner. The bundled version contains local compatibility edits, which remain subject to the underlying MIT grant and the applicable modification notice. |
| LibRangeCheck-3.0, `Libs/LibRangeCheck-3.0/` | Library minor `26` | <https://github.com/WeakAuras/LibRangeCheck-3.0>; <https://www.curseforge.com/wow/addons/librangecheck-3-0> | MIT License. The bundled header naming mitch0 and the WoWUIDev Community is retained. |
| LibSharedMedia-3.0, `Libs/LibSharedMedia-3.0/` | Revision `151`; library marker `8.2.0 v3` | <https://www.curseforge.com/wow/addons/libsharedmedia-3-0> | The embedded source explicitly states `License: LGPL v2.1`, names Elkano, and credits SurfaceLib by Haste/Otravi. A verbatim LGPL 2.1 text is supplied at `THIRD_PARTY_LICENSES/LGPL-2.1.txt`. The current CurseForge project field says All Rights Reserved; DragonflightUI_Luna relies only on the explicit LGPL header attached to this historical source copy and does not relicense it. |
| TaintLess, `Libs/TaintLess/TaintLess.xml` | `24-07-27` | <https://www.townlong-yak.com/addons/taintless> | All rights reserved. The source grants permission to distribute unmodified copies. DragonflightUI_Luna retains this file unmodified and preserves that notice exactly. |
| LibTradeSkillRecipes, `Libs/LibTradeSkillRecipes/` | Library minor `2`; embedded data set | <https://github.com/thespags/LibTradeSkillRecipes>; <https://www.curseforge.com/wow/addons/libtradeskillrecipes> | CurseForge identifies a BSD License and spags as owner. Original source files, data, test material, and author metadata are retained. DragonflightUI_Luna adds only the missing standard `xmlns`/`xmlns:xsi` declarations to `lib.xml`; its script list and behavior are unchanged. |
| LibClassicDurations, `Embed/AuraDurations/Libs/LibClassicDurations/` | Library minor `71` | <https://github.com/rgd87/LibClassicDurations>; <https://www.curseforge.com/wow/addons/libclassicdurations> | CurseForge identifies the library as MIT-licensed. The source header naming author d87 is retained. |
| AuraDurations wrapper, `Embed/AuraDurations/AuraDurations.lua` | `AuraDurations-1.0`, minor `2` | Inherited byte-for-byte from Dragonflight UI Classic commit `b8b35451d4621a8097e887385f72ec03e17765f1` | No separate file-level license header was found. It is treated as upstream project code only to the extent the upstream MIT grant validly covers it. |

## Existing license files that must remain

- `LICENSE` — Dragonflight UI Classic MIT License plus the DragonflightUI_Luna modification notice.
- `Libs/LICENSE.txt` — Ace3-style BSD license.
- `Libs/LibDeflate/LICENSE.txt` — GNU Lesser General Public License version 3 text bundled by LibDeflate.
- `Libs/LibEditModeOverride/LICENSE` — MIT License for LibEditModeOverride.
- `THIRD_PARTY_LICENSES/LGPL-2.1.txt` — GNU Lesser General Public License version 2.1 for the explicit LibSharedMedia source header.

The presence of MIT, BSD, zlib, LGPL, public-domain, and permission-only components in one archive is not a claim that they have been merged into one license. Recipients must follow the license attached to each component.

## Visual assets

The original supplied archive contained 280 BLP/TGA files. DragonflightUI_Luna V1.0 removes `Textures/Art/coffee.tga` because its only use was an in-game donation link. The remaining inherited assets are listed with SHA-256 hashes in `ASSET_MANIFEST.sha256`.

The remaining assets match the probable upstream commit byte-for-byte, but per-asset authorship and redistribution documentation was not present in the supplied archive. File names and visual function indicate that many reproduce or adapt World of Warcraft user-interface artwork. DragonflightUI_Luna:

- does not claim those assets were created by DragonflightUI_Luna;
- does not claim Blizzard or other third-party assets are licensed under MIT;
- preserves upstream file identity where an asset remains necessary for addon functionality; and
- recommends obtaining written confirmation from the upstream maintainer or relevant rights holder before making an unqualified all-content licensing claim.

See `ASSET_PROVENANCE.md` for the scope and residual manual-review warning.

## Trademarks

World of Warcraft, Warcraft, Blizzard Entertainment, Discord, GitHub, and other names or marks belong to their respective owners. References are used only for compatibility, attribution, and source identification. DragonflightUI_Luna is not affiliated with, endorsed by, sponsored by, or published by those owners.

## No warranty of legal clearance

These notices are a compliance-oriented record, not legal advice and not a representation that every right has been independently cleared.
