# WEYLAND-YUTANI CRT

**An *Alien* / Nostromo phosphor-green CRT boot experience for Nobara Linux (KDE Plasma).**

A cohesive theme that dresses up your whole startup in the *Weyland-Yutani* / MU-TH-UR
aesthetic - rolling scanlines, a soft phosphor sweep, and the winged-W emblem - from the
moment you power on to the moment your desktop appears.

![The GRUB boot menu](screenshots/grub-menu.png)

---

## What's included

The theme covers the three screens you see while the machine starts, in order:

1. **GRUB boot menu** - the themed entry picker (above), the first thing on screen.
2. **Boot splash** (Plymouth) - shown *before login* while the kernel and system load. **7 styles.**
3. **Plasma splash** (KDE) - the "Splash Screen" shown *after login* while the desktop loads. **4 styles.**

Every splash carries the rolling CRT scanline grille + sweep band (the one exception is the
Plasma **System Online**, which is deliberately clean). Pick any boot splash and any Plasma
splash independently - they don't have to match.

It's all built on a **handmade Weyland-Yutani CRT wallpaper** (an original 5120×1440 piece) -
every GRUB, boot, and splash background is derived from it, and it's included so you can set it
as your desktop too (see [`wallpaper/`](wallpaper/)).

---

## Screenshots

|  |  |
|---|---|
| **MU-TH-UR Console** - ship-computer self-test<br>![](screenshots/boot-muthur.png) | **System Online** - the emblem powers on<br>![](screenshots/plasma-online.png) |
| **Nostromo** - power gauge energizing<br>![](screenshots/nostromo.png) | **Emblem Ignition** - minimal, logo-led<br>![](screenshots/ignition.png) |

---

## ⭐ Recommended setup

**MU-TH-UR Console** boot splash + **System Online** Plasma splash - the ship's computer runs
its startup self-test as you boot, then the emblem powers on as your desktop comes up.

Run everything from **inside this folder** (`cd` into it first).

**1 · GRUB menu**
```bash
sudo rm -rf /boot/grub2/themes/weyland-crt
sudo mkdir -p /boot/grub2/themes
sudo cp -rT grub /boot/grub2/themes/weyland-crt
sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub
echo 'GRUB_THEME="/boot/grub2/themes/weyland-crt/theme.txt"' | sudo tee -a /etc/default/grub
sudo sed -i 's/^GRUB_TERMINAL_OUTPUT=/#&/' /etc/default/grub
grep -q '^GRUB_GFXMODE=' /etc/default/grub || echo 'GRUB_GFXMODE=auto' | sudo tee -a /etc/default/grub
grep -q '^GRUB_GFXPAYLOAD_LINUX=' /etc/default/grub || echo 'GRUB_GFXPAYLOAD_LINUX=keep' | sudo tee -a /etc/default/grub
sudo grub2-editenv - unset menu_auto_hide
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

**2 · Boot splash - MU-TH-UR Console**
```bash
sudo dnf install plymouth-plugin-script plymouth-plugin-label
sudo rm -rf /usr/share/plymouth/themes/weyland-muthur
sudo cp -rT plymouth/weyland-muthur /usr/share/plymouth/themes/weyland-muthur
sudo plymouth-set-default-theme -R weyland-muthur       # -R rebuilds the boot image (~1 min)
```

**3 · Plasma splash - System Online** (no root, no reboot)
```bash
mkdir -p ~/.local/share/plasma/look-and-feel
cp -r plasma-splash/weyland-online ~/.local/share/plasma/look-and-feel/
kbuildsycoca6
kwriteconfig6 --file ksplashrc --group KSplash --key Engine KSplashQML
kwriteconfig6 --file ksplashrc --group KSplash --key Theme weyland-online
```

Reboot to see it. Prefer a different look? Any option can be swapped in - see the tables below,
**[INSTALL.txt](INSTALL.txt)** for the full step-by-step, or just open the preview page.

---

## Preview before you commit

- **`index.html`** - open in a browser: an interactive picker that animates every option and
  **prints the exact commands** for whatever you select (GRUB / boot splash / Plasma splash).
- **`plasma-splash-preview.html`** - a live gallery of the four Plasma splashes.
- Preview a Plasma splash on the spot, no logout: `ksplashqml --test weyland-online`

---

## Requirements

- A **Fedora-based** distro - profiled and tested on **Nobara Linux** (KDE Plasma edition).
- **KDE Plasma 6** (for the Plasma splash; the GRUB + boot splashes are DE-agnostic).
- **GRUB2** and **Plymouth**, plus `plymouth-plugin-script` and `plymouth-plugin-label`
  (installed by step 2 above - without the label plugin the text splashes render blank).
- `sudo` for the GRUB + boot-splash steps. The Plasma splash installs into your home, no root.

---

## All options

### Boot splashes (Plymouth - before login)

| Theme | Style |
|---|---|
| `weyland-muthur` | **MU-TH-UR Console** - ship computer self-test → `STARTUP COMPLETE` |
| `weyland-online` | **System Online** - the Weyland-Yutani logo powers on + `ONLINE` |
| `weyland-nostromo` | **Nostromo** - emblem + power gauge energizing 0→100% |
| `weyland-ignition` | **Emblem Ignition** - the logo powers on. Minimal |
| `weyland-console` | **Console Log** - green boot log types out as the system loads |
| `weyland-bar` | **Progress Bar** - minimal bar that fills with boot progress |
| `weyland-standby` | **Standby Meter** - segmented meter, follows boot load 0→100% |

Switch splash any time: `sudo plymouth-set-default-theme -R weyland-<name>`

### Plasma splashes (KDE - after login)

| Theme | Style |
|---|---|
| `weyland-muthur` | **MU-TH-UR Console** - ship computer self-test |
| `weyland-online` | **System Online** - the logo powers on + `ONLINE` (clean, no scanlines) |
| `weyland-nostromo` | **Nostromo** - emblem + power gauge |
| `weyland-ignition` | **Emblem Ignition** - the emblem powers on |

Or pick one visually in **System Settings › Colors & Themes › Splash Screen** (hit ▶ to preview).

---

## Reverting

- **Boot splash:** `sudo plymouth-set-default-theme -R bgrt`
- **Plasma splash:** choose *Breeze* (or *None*) in the Splash Screen list, then
  `rm -r ~/.local/share/plasma/look-and-feel/weyland-*`
- **GRUB:** remove the `GRUB_THEME` and `GRUB_GFXPAYLOAD_LINUX` lines from `/etc/default/grub`,
  un-comment `GRUB_TERMINAL_OUTPUT`, then re-run the `grub2-mkconfig` line.

---

## Notes & credits

- **Wallpaper & CRT artwork - original, handmade by the theme's author.** The phosphor-green,
  scanlined background the entire theme is built on is hand-made original art (5120×1440 master);
  every GRUB / boot / splash background is derived from it.
- Font: **Share Tech Mono** (SIL Open Font License).
- A fan project - *Weyland-Yutani* and *Alien* are trademarks of 20th Century Studios; this is
  unofficial and not affiliated with or endorsed by the rights holders.
- Built and profiled on Nobara Linux / KDE Plasma 6. Full install reference: **[INSTALL.txt](INSTALL.txt)**.

> *"Building Better Worlds."*
