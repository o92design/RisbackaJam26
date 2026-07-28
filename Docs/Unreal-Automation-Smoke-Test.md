# Blueprint automation smoke test

The CI test runner is ready, but Unreal binary assets must be authored and saved by
Unreal Editor. Complete this once before enabling the Jenkins build jobs.

## Current status

The first milestone deliberately contains only these three inexpensive checks:

1. The world has a valid Game Instance.
2. The authoritative GameMode is `BP_CombatGameMode`.
3. A `BP_CombatCharacter` can be spawned.

`BP_AutomationSmoke` has been created and the nodes for all three checks have been laid
out. The close-up screenshots confirm that the success and failure routes are correct:

- [x] Game Instance failure ends with **Failed**; success continues to GameMode.
- [x] GameMode cast failure ends with **Failed**; success continues to character spawn.
- [x] Character failure ends with **Failed**; success registers the spawned actor for
      cleanup and ends with **Succeeded**.
- [x] The Blueprint has been moved to `/Game/RisbackaJam26/Tests`.
- [x] `L_AutomationSmoke` has been created in `/Game/RisbackaJam26/Tests`.
- [x] The character assertion message has been changed from `Game Instance is valid` to
      `BP_CombatCharacter is valid`.
- [x] Exactly one `BP_AutomationSmoke` actor is present in the level.
- [x] The corrected Blueprint has been compiled and saved.
- [x] The test passes in the Editor.
- [x] The test passes through the repository-level `Test.ps1` command.

Verified Editor result on 2026-07-28:

```text
Project.Functional Tests.RisbackaJam26.Tests.L_AutomationSmoke.BP_AutomationSmoke
Result: Success
Tests: 1, Failures: 0, Skipped: 0
Duration: 0.453 seconds
```

Verified command-line result on 2026-07-28:

```text
Project validation: Success
Blueprint functional tests: Success
Tests: 1, Failures: 0, Skipped: 0
Test duration: 0.501 seconds
Pipeline duration: 21.627 seconds
```

Do not move `.uasset` files with Windows Explorer. Moving the Blueprint in Unreal keeps
asset references and redirectors valid.

## Finish the current three-check graph

The white execution wires should form one success path:

```text
Event Start Test
  -> Assert Game Instance is valid
  -> Cast to BP_CombatGameMode
  -> Spawn and assert BP_CombatCharacter is valid
  -> Finish Test: Succeeded
```

Each failure output ends immediately in its own **Finish Test: Failed** node.

### 1. Game Instance

Keep the existing `Get Game Instance`, `Assert Is Valid`, and `Branch` nodes.

- Connect `Branch.True` to `Cast To BP_CombatGameMode`.
- Connect `Branch.False` to the nearby `Finish Test`.
- Set that `Finish Test` result to **Failed**.
- Use the message `World or Game Instance is invalid`.

This route is now verified as correct.

### 2. Combat GameMode

Keep `Get Game Mode` connected to the cast's `Object` input.

- Connect the normal cast-success execution output to
  `SpawnActor BP Combat Character`.
- Connect `Cast Failed` to the nearby `Finish Test`.
- Set that `Finish Test` result to **Failed**.
- Use the message `BP_CombatGameMode is not active`.

This route is now verified as correct.

### 3. Combat character

Keep the existing spawn transform at `Z = 200` and collision handling set to
**Always Spawn, Ignore Collisions**.

- Keep the spawned actor connected to `Assert Is Valid`.
- Change the assertion message to `BP_CombatCharacter is valid`.
- Connect `Branch.False` to the nearby `Finish Test`.
- Set that `Finish Test` result to **Failed**.
- Use the message `BP_CombatCharacter could not be spawned`.
- Connect `Branch.True` to `Register Auto Destroy Actor`, passing the spawned character
  as `Actor To Auto Destroy`.
- Connect that node to a final `Finish Test`.
- Set the final result to **Succeeded**.
- Use the message `RisbackaJam26 automation smoke test passed`.

Compile and save the Blueprint after correcting the graph.

## Required asset locations

Unreal paths beginning with `/Game` are virtual Content Browser paths. `/Game` maps to
the project's `Content` directory; it does not mean a directory outside the Unreal
project:

```text
/Game/RisbackaJam26/Tests
-> J:\dev\Projects\Unreal\RisbackaJam26\RisbackaJam26Game\Content\RisbackaJam26\Tests
```

Move the Blueprint in Unreal's Content Drawer and save it as:

```text
/Game/RisbackaJam26/Tests/BP_AutomationSmoke
```

To create that location inside Unreal:

1. Open the **Content Drawer** and select the top-level **Content** folder.
2. Right-click empty space and create a folder named `RisbackaJam26`.
3. Open it and create a folder named `Tests`.
4. Drag `BP_AutomationSmoke` from the existing `Content/Tests` folder into the new
   `Content/RisbackaJam26/Tests` folder.
5. Choose **Move Here** if Unreal asks whether to move or copy the asset.

Create a small empty level, place exactly one `BP_AutomationSmoke` actor, and save the
level as:

```text
/Game/RisbackaJam26/Tests/L_AutomationSmoke
```

The test level's path is significant. Unreal converts
`/Game/RisbackaJam26/Tests/L_AutomationSmoke` into an Automation Test path beginning
with `Project.Functional Tests.RisbackaJam26`, which is the filter used by CI.

In the test level's **World Settings**, set **GameMode Override** to
`BP_CombatGameMode`. This makes the GameMode check deterministic even if the project's
default map settings change later.

## Run the milestone

Pressing the regular **Play** button only starts Play In Editor. It does not invoke the
Functional Test manager, so the level will continue running until Play is stopped. The
`Event Start Test` graph runs only when the test is launched through Test Automation or
the command-line automation runner.

Before running, check the World Outliner and make sure the level contains exactly one
`BP_AutomationSmoke` actor.

1. Open **Tools -> Session Frontend**.
2. Select the **Automation** tab inside Session Frontend.
3. Enable the **Product** filter if the Functional Tests tree is hidden.
4. Click refresh or reopen Session Frontend if the newly saved level has not appeared.
5. Confirm the test appears below
   `Project -> Functional Tests -> RisbackaJam26`.
6. Select the test's checkbox and click **Start Tests**.
7. Confirm the result changes to **Success** and the message contains
   `Smoke Tests Success`.
8. Save all assets.
9. Open PowerShell in the repository root. Do not double-click `Test.ps1`, because the
   temporary PowerShell window may close before its result can be read.
10. Run:

   ```powershell
   .\Test.ps1
   ```

11. Confirm the new `.uasset` and `.umap` files appear in:

   ```powershell
   git lfs ls-files
   ```

## Deferred input-asset checks

Input-asset validation is intentionally deferred until the three-check milestone runs
successfully. The next small extension should validate these hard references:

```text
/Game/Input/IMC_Default
/Game/Input/Actions/IA_Move
/Game/Variant_Combat/Input/IMC_Combat
```

For each asset, drag it from the Content Drawer into the graph, pass it to
`Assert Is Valid`, and route a failed assertion to **Finish Test: Failed** with a
message naming that asset.

## CI contract

The headless runner uses:

```text
Project.Functional Tests.RisbackaJam26
```

It exports Unreal's JSON report to `TestOutput/UnrealReport`, converts it to
`TestOutput/junit.xml`, and fails when no matching test is found. Jenkins publishes the
JUnit report even when the test stage fails.

Keep the smoke map minimal. It should validate boot-critical assets in seconds, not play
through the game. Add focused Functional Test maps as systems become stable.
