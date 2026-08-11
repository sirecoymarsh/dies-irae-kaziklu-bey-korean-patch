# Third-Party Notices

## Noto Sans KR

This package includes two renamed copies of a font derived from **Noto Sans KR** inside the `files/data3.dat` Malie overlay so the engine can resolve the legacy family names used by the game.

- Source font: `NotoSansKR-VF.ttf` from the Windows font installation
- Packaged family name: `Dies Irae KR`
- Logical overlay entries:
  - `data\font\anticcezannepro.otf`
  - `data\font\tsukugopro-m.otf`
- License: SIL Open Font License 1.1
- License text: `licenses/OFL.txt`

The reserved font name requirements, if any, remain governed by the upstream license metadata. The modified font is redistributed under the same license.

## Build and validation tools not redistributed

The release payload does not include the external extraction or inspection binaries used during development. Development evidence may refer to:

- GARbro — MIT License
- SExtractor — GPL-3.0

Only the generated `data3.dat` overlay, locally authored installation scripts, manifests, documentation, and the OFL-covered font embedded in the overlay are included in this package.