#/bin/bash
flutter build linux
rm ~/bin/bldui
cp build/linux/x64/release/bundle/bldui ~/bin/bldui
