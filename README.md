Simple way to build a flatpak around the Firefox nightly binary builds.

> Tested on Fedora 25

```bash
# Pre-requirement
$ pkcon install flatpak

# Build
$ make

# Run the flatpak-ed Servo
$ flatpak run org.mozilla.Firefox --new-instance
# OR
$ make run-app
```
