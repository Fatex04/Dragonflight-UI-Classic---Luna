Run the regression checks from the repository root:

```text
python -m pip install lupa
python tests/layout_regressions.py
python tests/classic_regressions.py
```

The runner parses all Lua files with Lua 5.1 and executes the changed layout routines against simulated WoW frames, events and timers. It does not simulate WoW's secure execution/taint engine or replace in-game testing.

Before considering a client test complete:

- Click the center and edges of all twelve Action Bar 1 buttons, including after closing Edit Mode.
- Move and resize chat using its tab and native Edit Mode; check Save/Cancel, reload, relog and a loading screen.
- Check the bag bar on an existing and a new character, after bag changes and after a loading screen.
- Open Edit Mode from both Luna and the General chat menu; confirm one flight-path stop control and one selection per Luna system.
- Enter combat during Edit Mode and verify recovery afterwards without new protected-frame errors.
- Take a flight and confirm the native stop button works and disappears normally afterwards.
- Test a druid's alternate mana bar in shapeshift form and check BugSack for new errors.

Existing BugGrabber reports are historical. Compare new session errors without erasing the user's saved reports.

V1.3.2 focused checks cover player tooltip colors and guild-row placement, channel
ticks on Era/TBC/Wrath/Cata, missing spell names, optional season APIs/enums and
malformed version-message payloads. These use isolated Lua 5.1 fixtures.

V1.3.2 live checks:

- Hover players with class name/border, title, realm and guild options enabled;
  hide the guild and check that no empty row remains.
- Enable player castbar ticks and channel Drain Life or Arcane Missiles on TBC;
  check rank-specific markers. Check the existing counts on Era/SoD, Wrath and Cata/Mists.
- Check startup and new BugSack reports after updating. Profiles and saved layouts
  should remain intact; the automated fixtures do not replace this client check.

V1.3.1 live checks:

- Move player, target and possess selections in Edit Mode, close it, reload and cross a loading screen; verify the saved positions persist.
- Change targets repeatedly and enter/leave combat; check positions, scale, click targeting and BugSack.
- Activate possession (for example Mind Control), check that its buttons work and that the native bar disappears when possession ends.
- Log in with a watched friendly faction and verify that no green reputation bar flashes in the center.
