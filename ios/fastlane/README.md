fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Install App Store signing files from the match repo

Pass readonly:false once to create them on the Apple Developer portal

Pass force:true with it to remake the profile, e.g. after turning on

a capability such as Associated Domains for the app ID

### ios version

```sh
[bundle exec] fastlane ios version
```

Print the version the next release uses; see release_version

Pass bump:minor or bump:major for a feature or major release

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build a signed IPA and upload it to TestFlight

Uses APP_VERSION when set (CI), otherwise picks the version itself

Pass skip_upload:true to build and sign without uploading

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
