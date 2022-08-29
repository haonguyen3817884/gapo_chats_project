fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios staging
```
fastlane ios staging
```

### ios upload_staging
```
fastlane ios upload_staging
```

### ios release
```
fastlane ios release
```
---------> Appstore
### ios upload_ipa
```
fastlane ios upload_ipa
```

### ios submit_review
```
fastlane ios submit_review
```
Submiting exist TestFlight build to review
### ios refresh_dsyms
```
fastlane ios refresh_dsyms
```

### ios upload_testflight
```
fastlane ios upload_testflight
```


----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
