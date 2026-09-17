# Working with the Xcode project

The Xcode project is generated from [`project.yml`](project.yml). Do not edit
`v2.xcodeproj/project.pbxproj` by hand; make project changes in the spec and
regenerate it.

## First-time setup

```sh
./scripts/generate-xcodeproj.sh
```

The script creates `Config/Local.xcconfig` locally when it does not exist.
Set `DEVELOPMENT_TEAM` to the Team ID from the engineer's Apple Developer
account. `PRODUCT_BUNDLE_IDENTIFIER_PREFIX` should be unique to that team or
engineer if multiple installations must coexist. The local file is ignored by
git, so engineers can use different teams without producing project-file
conflicts.

## Daily workflow

```sh
xcodegen generate
xcodebuild -project v2.xcodeproj -scheme v2 -showBuildSettings
```

Use Xcode's normal Run/Test actions after generation. Signing is automatic and
uses the local Team ID. Simulator builds do not require a development team;
device and archive builds do.
