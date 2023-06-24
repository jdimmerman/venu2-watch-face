connectiq
java -Xms1g \
    -Dfile.encoding=UTF-8 \
    -Dapple.awt.UIElement=true \
    -jar '/Users/jimmerman/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-6.2.0-2023-05-26-cc5fddb5d/bin/monkeybrains.jar' \
    -o bin/JasonWatchFace.prg \
    -f /Users/jimmerman/JasonWatchFace/monkey.jungle \
    -y /Users/jimmerman/JasonWatchFace/developer_key \
    -d venu2_sim \
    -w 
monkeydo bin/JasonWatchFace.prg venu