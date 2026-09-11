Run the regression checks from the repository root:

```text
python -m pip install lupa
python tests/layout_regressions.py
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
