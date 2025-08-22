#!/data/data/com.termux/files/usr/bin/bash

# YouTube 24x7 RTMP Live Stream Script with Profile Management & Audio Mode
CONFIG_DIR="$HOME/.ytlive_profiles"
mkdir -p "$CONFIG_DIR"

list_profiles() {
    echo "📂 Available Profiles:"
    if [ "$(ls -A $CONFIG_DIR)" ]; then
        ls "$CONFIG_DIR"
    else
        echo "❌ No profiles found."
    fi
    echo
}

create_profile() {
    echo "🎥 Enter profile name (no spaces):"
    read PROFILE
    echo "🎥 Enter your video/audio file path (example: /sdcard/video.mp4 or /sdcard/audio.mp3):"
    read MEDIA_PATH
    echo "🖼️ Enter image file path (leave blank if using video):"
    read IMAGE_PATH
    echo "🔑 Enter your YouTube Stream Key:"
    read STREAM_KEY

    echo "MEDIA_PATH=\"$MEDIA_PATH\"" > "$CONFIG_DIR/$PROFILE"
    echo "IMAGE_PATH=\"$IMAGE_PATH\"" >> "$CONFIG_DIR/$PROFILE"
    echo "STREAM_KEY=\"$STREAM_KEY\"" >> "$CONFIG_DIR/$PROFILE"
    echo "✅ Profile '$PROFILE' saved!"
}

select_profile() {
    list_profiles
    echo "👉 Enter profile name to load:"
    read PROFILE
    if [ -f "$CONFIG_DIR/$PROFILE" ]; then
        source "$CONFIG_DIR/$PROFILE"
        echo "✅ Loaded profile: $PROFILE"
    else
        echo "❌ Profile not found!"
        exit 1
    fi
}

edit_profile() {
    list_profiles
    echo "✏️ Enter profile name to edit:"
    read PROFILE
    if [ -f "$CONFIG_DIR/$PROFILE" ]; then
        source "$CONFIG_DIR/$PROFILE"

        echo "🎥 Enter new media file path (leave blank to keep old: $MEDIA_PATH):"
        read MEDIA_PATH_NEW
        echo "🖼️ Enter new image path (leave blank to keep old: $IMAGE_PATH):"
        read IMAGE_PATH_NEW
        echo "🔑 Enter new YouTube Stream Key (leave blank to keep old):"
        read STREAM_KEY_NEW

        if [ -n "$MEDIA_PATH_NEW" ]; then MEDIA_PATH="$MEDIA_PATH_NEW"; fi
        if [ -n "$IMAGE_PATH_NEW" ]; then IMAGE_PATH="$IMAGE_PATH_NEW"; fi
        if [ -n "$STREAM_KEY_NEW" ]; then STREAM_KEY="$STREAM_KEY_NEW"; fi

        echo "MEDIA_PATH=\"$MEDIA_PATH\"" > "$CONFIG_DIR/$PROFILE"
        echo "IMAGE_PATH=\"$IMAGE_PATH\"" >> "$CONFIG_DIR/$PROFILE"
        echo "STREAM_KEY=\"$STREAM_KEY\"" >> "$CONFIG_DIR/$PROFILE"
        echo "✅ Profile '$PROFILE' updated!"
    else
        echo "❌ Profile not found!"
    fi
}

delete_profile() {
    list_profiles
    echo "🗑️ Enter profile name to delete:"
    read PROFILE
    if [ -f "$CONFIG_DIR/$PROFILE" ]; then
        rm "$CONFIG_DIR/$PROFILE"
        echo "✅ Profile '$PROFILE' deleted!"
    else
        echo "❌ Profile not found!"
    fi
}

# Main menu
while true
do
    echo "=============================="
    echo "  🎬 YouTube 24x7 Live Script "
    echo "=============================="
    echo "1️⃣ Create new profile"
    echo "2️⃣ Use existing profile"
    echo "3️⃣ Edit profile"
    echo "4️⃣ Delete profile"
    echo "5️⃣ Exit"
    echo -n "👉 Choose an option [1-5]: "
    read OPTION

    case $OPTION in
        1) create_profile ;;
        2) select_profile && break ;;
        3) edit_profile ;;
        4) delete_profile ;;
        5) exit ;;
        *) echo "❌ Invalid option";;
    esac
done

# Prevent phone from sleeping
termux-wake-lock

# Start streaming loop
while true
do
    if [ -n "$IMAGE_PATH" ]; then
        echo "🎧 Audio mode with static image"
        ffmpeg -re -stream_loop -1 -i "$MEDIA_PATH" -loop 1 -i "$IMAGE_PATH" \
        -c:v libx264 -preset veryfast -tune stillimage -b:v 1500k \
        -c:a aac -b:a 128k -ar 44100 -shortest \
        -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
    else
        echo "🎥 Video mode"
        ffmpeg -re -stream_loop -1 -i "$MEDIA_PATH" \
        -c:v libx264 -preset veryfast -b:v 2500k \
        -c:a aac -b:a 128k -ar 44100 \
        -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
    fi

    echo "⚠️ Stream crashed... restarting in 5 seconds"
    sleep 5
done
