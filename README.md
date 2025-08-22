
A lightweight Termux-based script to stream 24×7 live video or audio to YouTube Live using FFmpeg.
It supports multiple profiles, auto-reconnect, and both video looping & radio-style audio streaming.


---

✨ Features

📺 24×7 Video Mode – loop a video file endlessly to YouTube

🎶 Audio Radio Mode – stream audio with a static image

🔑 Multiple Profiles – manage different stream keys & files for multiple channels

🔄 Auto-reconnect – keeps stream alive if connection drops

🔋 Battery-safe – prevents phone from sleeping (termux-wake-lock)

📱 Android Only – no PC required, works entirely in Termux



---

🔧 Installation

1. Install Termux


2. Update and install dependencies:

pkg update && pkg upgrade -y
pkg install ffmpeg termux-api -y
termux-setup-storage


3. Clone this repo:

git clone https://github.com/yourusername/ytlive-termux.git
cd ytlive-termux
chmod +x ytlive.sh




---

▶️ Usage

Run:

./ytlive.sh

Menu Options

1. ➕ Create new profile (video/audio path + stream key)


2. 🎬 Use existing profile


3. ✏️ Edit profile


4. ❌ Delete profile


5. 🚪 Exit




---

🎥 Example

Video Stream

./ytlive.sh

Select Create Profile

Video: /sdcard/video.mp4

Stream Key: xxxx-xxxx-xxxx-xxxx


👉 Loops video 24×7 on YouTube.

Audio Stream (Radio)

./ytlive.sh

Select Create Profile

Audio: /sdcard/song.mp3

Image: /sdcard/logo.png

Stream Key: xxxx-xxxx-xxxx-xxxx


👉 Streams audio with static image.


---

📌 Notes

Get your YouTube Stream Key from [YouTube Studio → Go Live → Stream Settings].

Store media files in /sdcard/ for easy access.

Use stable internet + charging for 24×7 streaming.



---

🏷️ Tags

termux youtube-live ffmpeg livestreaming rtmp automation android bash-script


---

🔥 Ready to go live straight from your phone!


---
