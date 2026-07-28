# Blueprint automation smoke test

The CI test runner is ready, but Unreal binary assets must be authored and saved by Unreal Editor. Complete this once before enabling either Jenkins job.

## Create the assets

1. Open `RisbackaJam26Game.uproject` in Unreal Engine 5.8 and allow the new editor plugins to load.
2. Create `Content/RisbackaJam26/Tests`.
3. Create a Blueprint Class whose parent is **Functional Test**. Name it `BP_AutomationSmoke`.
4. In that Blueprint, override the test-start event exposed by `FunctionalTest`.
5. Add inexpensive checks for the current baseline:
   - the world is valid;
   - the authoritative GameMode is `BP_CombatGameMode`;
   - at least one `BP_CombatCharacter` can exist;
   - movement input assets required by the Combat character are loadable.
6. On success, call **Finish Test** with result **Succeeded** and a useful message. On any failed condition, call it with **Failed** and a message naming the missing object.
7. Create a small empty test level, place one `BP_AutomationSmoke` actor, and save it exactly as:

   `/Game/RisbackaJam26/Tests/L_AutomationSmoke`

8. Open **Tools → Test Automation**, enable Developer/Smoke filters if needed, and confirm the test appears under `Project → Functional Tests → RisbackaJam26`.
9. Run it once in the Editor, then run from the repository root:

   ```powershell
   .\Test.ps1
   ```

10. Commit the new `.uasset` and `.umap` files and confirm both appear in `git lfs ls-files`.

## CI contract

The headless runner uses:

```text
Project.Functional Tests.RisbackaJam26
```

It exports Unreal's JSON report to `TestOutput/UnrealReport`, converts it to `TestOutput/junit.xml`, and fails when no matching test is found. Jenkins publishes the JUnit report even when the test stage fails.

Keep the smoke map minimal. It should validate boot-critical assets in seconds, not play through the game. Add focused Functional Test maps as systems become stable.
