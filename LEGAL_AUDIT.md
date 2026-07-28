# DragonflightUI_Luna Legal and Publication Audit

Audit date: 24 July 2026  
Scope: supplied `DragonflightUI_Luna_original.zip`, prepared upload `DragonflightUI_Luna.zip`, and installed `DragonflightUI` directory  
Purpose: compliance-oriented preparation of an independently maintained fork named DragonflightUI_Luna  
Legal-advice status: **This document is not legal advice and does not guarantee legal, copyright, or trademark clearance.**

## 1. Executive summary

The supplied ZIP and installed addon originally contained 616 files and were byte-for-byte identical. The package is a copied archive, not a Git working tree.

The probable source base is Dragonflight UI Classic `v0.40.3`, commit `b8b35451d4621a8097e887385f72ec03e17765f1`. Exact fork provenance cannot be proven because `.git` history is absent.

Publication preparation performed for DragonflightUI_Luna V1.0:

- preserved the upstream MIT license and exact upstream copyright notice;
- corrected the DragonflightUI_Luna modification notice;
- documented mixed third-party licenses without relicensing dependencies;
- replaced copied upstream promotional description text with original DragonflightUI_Luna text;
- corrected unsupported contributor claims;
- removed in-game donation solicitation, supporter-benefit text, and its coffee artwork;
- removed the original project's CurseForge ID from DragonflightUI_Luna metadata;
- added third-party, contributor, asset-provenance, CurseForge, and audit documents;
- created a distinct project avatar without Blizzard or World of Warcraft branding; and
- retained the technical `DragonflightUI` folder, saved-variable name, and namespaces to avoid breaking functionality.

## 2. Final status

**BLOCKED for any claim that the entire archive is unconditionally MIT-licensed or fully rights-cleared.**

**Prepared for a disclosed, independently branded submission with residual manual review.**

The remaining blocker is not an identified unlawful file. It is the absence of authoritative per-asset origin and redistribution evidence for the inherited BLP/TGA texture set, plus a current project-page/license-field discrepancy for the historical LibSharedMedia copy. Written confirmation from the upstream maintainer or relevant rights holder is the safest resolution.

## 3. Artifact identity

| Artifact | Evidence |
| --- | --- |
| Original ZIP | `C:\Users\bayram\Desktop\WoWaddons\DragonflightUI_Luna_original.zip` |
| Original ZIP SHA-256 | `67203E47EC25EE3A2592FABAF17A6E05F8B0E9F3FD5E88B57C52638A1F34908E` |
| Installed tree | `D:\Battle.net Games\World of Warcraft\_classic_era_\Interface\AddOns\DragonflightUI` |
| Original file count | 616 |
| Original total uncompressed bytes | 73,971,094 |
| ZIP versus installed tree | 616 identical files; 0 missing, 0 extra, 0 changed |
| Repository type | Copied archive; no `.git` directory |

The timestamps show when these local artifacts were written, not where or when the source was originally acquired. Acquisition source and date remain **UNVERIFIED**.

## 4. Exact upstream provenance

Expected upstream:

- Repository: <https://github.com/Karl-HeinzSchneider/WoW-DragonflightUI>
- CurseForge: <https://www.curseforge.com/wow/addons/dragonflight-ui-classic>
- Probable version: `v0.40.3`
- Probable commit: [`b8b35451d4621a8097e887385f72ec03e17765f1`](https://github.com/Karl-HeinzSchneider/WoW-DragonflightUI/commit/b8b35451d4621a8097e887385f72ec03e17765f1)

Comparison against that pinned commit, after normalizing text line endings:

| Result | Count |
| --- | ---: |
| Exact same-path matches | 576 |
| Different same-path files | 34 |
| DragonflightUI_Luna-local files before publication preparation | 6 |
| Upstream-only repository files | 45 |
| Visual assets compared | 280 |
| Byte-identical visual assets | 280 |

This is strong evidence for the probable base but is not equivalent to a verifiable Git merge base.

## 5. Upstream license

The pinned upstream `LICENSE` is MIT and contains:

`Copyright (c) 2022 Karl-HeinzSchneider`

Pinned evidence:

<https://raw.githubusercontent.com/Karl-HeinzSchneider/WoW-DragonflightUI/b8b35451d4621a8097e887385f72ec03e17765f1/LICENSE>

The DragonflightUI_Luna root `LICENSE` preserves that line and adds:

`Copyright (c) 2026 Femboybaddie (modifications for DragonflightUI_Luna only)`

The MIT grant is not described as overriding separately licensed libraries, documentation, artwork, or trademarks.

## 6. License conflict and mixed-license scan

| Finding | Status | Treatment |
| --- | --- | --- |
| Root project code uses MIT | PASS | Original text and notice preserved |
| Ace3 components use Ace3-style BSD terms | PASS WITH NOTICE | `Libs/LICENSE.txt` preserved |
| LibDeflate code says zlib while bundled examples/docs/license contain LGPL-3.0 material | MIXED LICENSE | Both sets of notices preserved and scoped in `THIRD_PARTY_NOTICES.md` |
| LibSharedMedia embedded source says LGPL 2.1 while current CurseForge field says All Rights Reserved | MANUAL REVIEW | Source header preserved; full LGPL 2.1 text added; no MIT relicensing claim |
| TaintLess allows distribution only of unmodified copies | PASS WITH CONDITION | File verified unchanged relative to probable upstream base; notice preserved |
| Other MIT/BSD/public-domain libraries | PASS WITH NOTICE | Sources, roles, and license evidence documented |
| Inherited texture rights | UNVERIFIED | Separate manifest and warning; no MIT ownership claim |

Full dependency evidence is in `THIRD_PARTY_NOTICES.md`.

## 7. Contributor verification

| Person | Evidence-based classification |
| --- | --- |
| Karl-HeinzSchneider / KarlHeinz_Schneider | Original creator, upstream maintainer, and original copyright holder |
| Femboybaddie | DragonflightUI_Luna fork maintainer and modification copyright claimant |
| MendleM | Author of open upstream PR #693; local inclusion unverified |
| Icebreethe | Author of open upstream PR #691; local inclusion unverified |
| boang3000 | Author of open upstream PR #686; local inclusion unverified |
| CadoCat | Author of open upstream PR #687; local inclusion unverified |
| iHoody | UNVERIFIED; no authoritative matching role evidence found |

No candidate is added to the root copyright notice.

## 8. Asset audit

The original package contained 249 BLP and 31 TGA files. All 280 matched the probable upstream commit byte-for-byte.

For V1.0, `Textures/Art/coffee.tga` was removed because it supported the in-game donation link. The final inventory is generated in `ASSET_MANIFEST.sha256`.

Classification of remaining gameplay assets:

- original DragonflightUI_Luna content: no;
- inherited upstream content: yes;
- byte-identical to probable upstream: yes;
- asset-by-asset creator and license: UNVERIFIED;
- possible Blizzard/game-derived interface artwork: MANUAL REVIEW REQUIRED;
- represented as DragonflightUI_Luna-owned MIT artwork: no.

The separately supplied project avatar is AI-generated, not derived from an input image, and disclosed in `CURSEFORGE_DESCRIPTION.md` and `ASSET_PROVENANCE.md`.

## 9. Branding and name risks

- `Luna` already appears in the WoW addon ecosystem, including Luna Unit Frames. The more specific `DragonflightUI_Luna` name reduces, but does not eliminate, possible discoverability or confusion issues.
- No trademark-safety claim is made.
- A manual search of DPMAregister, EUIPO eSearch, and relevant project platforms is still recommended before publication.
- The package folder remains `DragonflightUI` solely for compatibility.
- TOC metadata clearly identifies DragonflightUI_Luna as an independently maintained fork and links the upstream project.
- The original CurseForge project ID `819757` is not used as DragonflightUI_Luna's project ID.

## 10. Blizzard addon-policy checklist

Policy reference:

<https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642>

| Requirement | Status after preparation | Evidence |
| --- | --- | --- |
| Addon distributed free of charge | PASS | No payment gate or paid feature found |
| Addon code visible | PASS | Lua/XML source is distributed unobfuscated |
| No advertisements or commercial promotion in game | PASS WITH WARNING | Donation block removed; Discord and upstream-source links remain informational |
| No donation solicitation in game | PASS | BuyMeACoffee URL, supporter text, and coffee toolbar entry removed |
| No premium/donor-only functionality | PASS | No gated feature found |
| No hidden, encrypted, or obfuscated code | PASS | Static scan found normal source and standard libraries only |
| No excessive messaging or traffic | PASS WITH RUNTIME CHECK | Version communication uses the `DragonflightUI` addon-message prefix; no stress test performed |
| No offensive user-facing material | PASS WITH LIMITATION | No obvious material found in static text scan |
| Compliance with Terms of Use/EULA | MANUAL REVIEW | Cannot be guaranteed by static source inspection |
| No external executable code | PASS | No executable, DLL, script launcher, or nested archive is included |

## 11. CurseForge checklist

Policy references:

- <https://support.curseforge.com/support/solutions/articles/9000197279-project-and-modpack-moderation-policies>
- <https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips>
- <https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project>

| Requirement | Status |
| --- | --- |
| MIT selected for DragonflightUI_Luna project code | READY, with mixed-license notice |
| Distinct project name | WARNING: manual name clearance recommended |
| Distinct 400×400 project avatar | READY |
| One-sentence English summary | READY in `CURSEFORGE_DESCRIPTION.md` |
| Original English description | READY; prior copied text replaced |
| Clear differences from upstream | READY |
| Visible upstream credit and links | READY |
| No official-Blizzard implication | READY |
| No third-party image in avatar | READY based on generation process; no guarantee of uniqueness |
| No external download link | READY |
| No paid/donor-only features | READY |
| Donation only on distribution page | READY; no donation information included |
| AI promotional-image disclosure | READY |

## 12. Unverified facts and residual manual checks

1. Exact source-acquisition date and route.
2. Exact Git merge base and authorship of each DragonflightUI_Luna code change.
3. Per-asset authorship and redistribution rights for inherited BLP/TGA files.
4. Whether the LibSharedMedia historical LGPL header is sufficient for the exact embedded copy despite the current CurseForge project field.
5. Trademark and confusing-similarity clearance for `DragonflightUI_Luna`.
6. Runtime behavior on every TOC-targeted Classic client.
7. Final acceptance by CurseForge moderation or Blizzard.

## 13. Files created or changed for publication preparation

Created:

- `LEGAL_AUDIT.md`
- `THIRD_PARTY_NOTICES.md`
- `CONTRIBUTORS.md`
- `CURSEFORGE_DESCRIPTION.md`
- `ASSET_PROVENANCE.md`
- `ASSET_MANIFEST.sha256`
- `THIRD_PARTY_LICENSES/LGPL-2.1.txt`
- separate project avatar `Luna_Project_Avatar_400x400.png`

Changed:

- `LICENSE`
- `README.md`
- `CHANGELOG.md`
- all six root TOC variants
- `Mixin/Config.mixin.lua`
- four localization files containing the removed donation toolbar text
- `Libs/LibTradeSkillRecipes/lib.xml` (namespace declarations only)

Removed:

- `Textures/Art/coffee.tga`

No gameplay module, saved-variable name, internal namespace, or main addon directory was renamed.

## 14. Reproducible audit commands

The audit used read-only Git, ripgrep, PowerShell, GitHub API, archive, hash, and web-source queries. The central reproducible command set is:

```powershell
git -C <addon> rev-parse --is-inside-work-tree
git -C <addon> remote -v
git -C <addon> branch --show-current
git -C <addon> rev-parse HEAD
git -C <addon> tag --list
rg -n -i --hidden '(copyright|licensed?|SPDX|\bMIT\b|\bGPL\b|\bLGPL\b|\bBSD\b|\bApache\b|\bMPL\b|authors?|contributors?|credits?|third[- ]party)' <addon>
rg -n -i '(buymeacoffee|donat|patreon|paypal|premium|subscription|supporter|exclusive perks)' <addon>
rg -n '(RegisterComm|SendCommMessage|SendAddonMessage|C_ChatInfo|loadstring|debug\.|getfenv|setfenv)' <addon>
Get-FileHash -Algorithm SHA256 <file>
Get-ChildItem -Recurse -File <addon>
```

ZIP entry hashes were computed in memory with `System.IO.Compression.ZipFile` and SHA-256. Upstream comparison used the pinned GitHub codeload archive for commit `b8b35451d4621a8097e887385f72ec03e17765f1` without extracting it into the addon directory.

## 15. Publication decision

DragonflightUI_Luna V1.0 is materially better documented and removes the clear in-game donation-policy problem. It may be submitted only with the supplied attribution, mixed-license, unofficial-project, asset-scope, and AI-image disclosures intact.

Do not describe it as “completely legally safe,” “all content MIT,” “trademark cleared,” or “official.” Written rights confirmation for the inherited texture bundle remains the strongest next step.
