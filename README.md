# 💚 KWin Opacity Fix 💚
____
__A Bash script to slap a 95% opacity on specific app windows in a KDE desktop running KWin with X11. It hits up apps like Brave, Chrome, Telegram, KWrite, Remmina, and KDE portals, giving them a slick transparent look. Logs all the action to a file in the script’s directory.__
____
__Why this? KWin’s built-in window rules were supposed to handle opacity, but they flopped—buggy or just plain ignored. So, I cooked up this script to force it to work, no messing around__
____
## 🔥 Features

__- Sets window opacity to 95% (`0xf3333332`) for a clean vibe.__
__- Targets Brave, Chrome, Telegram, KWrite, Remmina, and KDE portal windows.__
__- Logs everything to `opacity_multi_apps.log` in the same directory.__
__- Forces opacity with KWin hacks if needed.__
__- Runs until all target apps are handled, then bails.__
____
## 🤔 Requirements

__- KDE desktop with KWin on X11 (tested on Garuda Linux).__
__- Tools needed: `xdotool`, `xprop`, `xwininfo`, `kwin_x11`. Install them with this command:__
__  ```bash__
__  sudo pacman -S xdotool xorg-xprop xorg-xwininfo kwin__
____
__- Bash (already on Linux, no install needed).__
____
__## 🏃‍➡️ How to Run for Testing (One-Time)__
__Everything you need to test it once is right here:__
____
__1. **Clone the repo**:__
__ - Open a terminal and run:__
__ - git clone https://github.com/yourusername/kwin-opacity-fix.git__
____
__- Move into the folder:__
____
____
__2. **Make it executable**:__
__- Run this in the terminal:__
____
____
__3. **Run it once**:__
__- Start the script with:__
____
__./kwin_opacity_fix.sh__
____
____
__- Open some apps it targets (like Brave or Telegram) while it runs to see the opacity kick in.__
____
__4. **Check the log**:__
__- Look at the log file it makes:__
____
__- You’ll see what it did—opacity changes, errors, or whatever. It stops when all listed apps are done or if no windows show up.__
____
__## Adding to Autostart (KDE)__
__If you like it and want it to run every time you log into KDE, follow these steps:__
____
### 👾 GUI Method
____
__1. **Open KDE System Settings**:__
__- Open the app called `System Settings` (find it in your menu).__
__- Go to `Startup and Shutdown` > `Autostart`.__
____
__2. **Add the script**:__
__- Click `Add...` and pick `Script`.__
__- Click the folder icon, find `~/Scripts/kwin_opacity_fix.sh` (or wherever you put it), and select it.__
__- In "Run On", choose `Pre-KDE Startup` (so KWin catches windows early).__
__- Click `OK`.__
____
__3. **Test it**:__
__- Log out of KDE (click your user, then `Log Out`).__
__- Log back in. The script runs automatically and tweaks opacity.__
____
### 🥷🏽 Terminal Method
__1. **Move the script** (optional, same as above):__
__- Make a folder:__
__- Move it:__
__mkdir -p ~/Scripts__
__mv kwin_opacity_fix.sh ~/Scripts/__
__ln -s ~/Scripts/kwin_opacity_fix.sh ~/.config/autostart-scripts/__
____
____
__2. **Test it**:__
__- Log out:__
____
____
__(Or just log out via the menu.)__
__- Log back in. It’ll run on startup.__
____
## Notes
__- Waits 5 seconds at the start so KWin and the desktop can load.__
__- If opacity flops (like KWin rules did), it tries forcing it or restarts `kwin_x11` with:__
__- kwin_x11 --replace &__
____
____
# 👨🏻‍💻 FOR MORE INFORMATION AND SUPPORT 👨🏻‍💻
____
__[TELEGRAM](https://t.me/rex_cc) | __
__[FACEBOOK](https://www.facebook.com/graybyt3) | __
__[X](https://x.com/gray_byte) | __
__[INSTAGRAM](https://www.instagram.com/gray_byte)__

