# Contributing

## Branch and commit policy

- `master` is the only long-lived branch and must remain buildable.
- Pull before starting work and push small, coherent commits.
- Use short-lived branches only when work genuinely cannot land incrementally.
- Commit messages should be imperative and specific, for example `Add barricade placement preview`.
- Do not commit generated Unreal, Visual Studio, test, log, or package output.

## Binary Unreal assets

`.uasset` and `.umap` files are Git LFS objects and cannot be meaningfully merged.

Before editing a shared map, GameMode, player Blueprint, input mapping, or other central asset:

1. Tell the other developer which asset you are taking.
2. Pull immediately before opening it.
3. Make and test the smallest useful edit.
4. Save, commit, and push it promptly.
5. Tell the other developer the asset is free again.

Prefer separate feature Blueprints, components, data assets, and sublevels so Oskar and Daniel can work in parallel. Git LFS locking is optional and manual; it is not globally required for this two-person jam.

## Content organization

Put new game-owned content below:

```text
Content/RisbackaJam26/
├─ Core/
├─ Characters/
├─ Building/
├─ Enemies/
├─ UI/
├─ Maps/
├─ Audio/
└─ Tests/
```

Keep marketplace/vendor content in a clearly named top-level folder. Avoid modifying vendor assets directly; derive or duplicate into `Content/RisbackaJam26/`.

## Before pushing

```powershell
git lfs status
.\Test.ps1
git status
```

Verify that only intended files are staged. Never commit API keys, tokens, passwords, `Saved/`, `Intermediate/`, `DerivedDataCache/`, `BuildOutput/`, or `Content/Developers/`.

## Clean-clone gate

Before the jam begins, Daniel should clone the repository on his development computer, run `git lfs pull`, open the project with UE 5.8, run the smoke test, and launch the Combat map. This catches LFS, engine-version, plugin, and local-tooling problems while there is still time to fix them.
