# 🚀 GHAA SCRIPTER ROBLOX - Advanced Announcement System

## 📋 Deskripsi
Script announcement system yang canggih untuk Roblox Studio dengan command `!a (pesan)` yang hanya bisa diakses oleh username "ghawan2". Sistem ini menampilkan notifikasi yang menarik untuk seluruh player dengan animasi dan sound effects.

## ✨ Fitur Utama

### 🎮 Command System
- **Command**: `!a (pesan)`
- **Admin Only**: Username "ghawan2"
- **Cooldown**: 5 detik antar announcement
- **Validation**: Cek admin dan cooldown otomatis

### 🎨 UI Design yang Menarik
- **Gradient Background**: Biru ke merah yang elegan
- **Smooth Animations**: Slide in/out dengan easing
- **Pulse Effect**: Animasi berkelanjutan
- **Modern Design**: Corner radius dan shadows
- **Responsive**: Auto-adjust untuk berbagai ukuran layar

### 🔊 Sound & Effects
- **Notification Sound**: Electronic ping sound
- **Hover Effects**: Button interactions
- **Auto Close**: Tutup otomatis setelah 8 detik
- **Manual Close**: Tombol X untuk tutup manual

### 🛡️ Security Features
- **Admin Restriction**: Hanya username "ghawan2"
- **Access Denied UI**: Error message untuk non-admin
- **Cooldown System**: Mencegah spam
- **Input Validation**: Cek pesan kosong

## 📁 Cara Instalasi

### 1. Server Script (ServerScriptService)
```lua
-- Paste seluruh kode AnnouncementSystem.lua ke dalam ServerScript
-- Script akan otomatis membuat RemoteEvents di ReplicatedStorage
```

### 2. RemoteEvents (Otomatis dibuat)
Script akan otomatis membuat:
- `AnnouncementEvent` - Untuk mengirim ke semua client
- `AnnouncementRequest` - Untuk menerima request dari client

### 3. Sound Setup (Otomatis)
Script akan otomatis membuat sound effect di SoundService

## 🎯 Cara Penggunaan

### Untuk Admin (ghawan2):
1. Ketik di chat: `!a Selamat datang di server kami!`
2. Semua player akan menerima notifikasi yang menarik
3. Tunggu 5 detik untuk announcement berikutnya

### Untuk Non-Admin:
- Akan mendapat error message "Access Denied"
- Tidak bisa menggunakan command

## 🔧 Konfigurasi

### Mengubah Admin Username:
```lua
local ADMIN_USERNAME = "username_baru"
```

### Mengubah Command Prefix:
```lua
local COMMAND_PREFIX = "!announce"
```

### Mengubah Cooldown:
```lua
local ANNOUNCEMENT_COOLDOWN = 10 -- seconds
```

### Mengubah Sound:
```lua
NotificationSound.SoundId = "rbxasset://sounds/your_sound.wav"
```

## 🎨 Customization

### Mengubah Warna Theme:
```lua
-- Di function createAnnouncementGUI, ubah gradient colors:
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), -- Merah
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)), -- Hijau
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255)) -- Biru
}
```

### Mengubah Durasi Auto Close:
```lua
-- Di function createAnnouncementGUI:
wait(10) -- Ubah dari 8 ke 10 detik
```

### Mengubah Ukuran GUI:
```lua
-- Di function createAnnouncementGUI:
mainFrame.Size = UDim2.new(0, 800, 0, 250) -- Lebih besar
```

## 🐛 Troubleshooting

### Problem: Command tidak bekerja
**Solution**: Pastikan script ada di ServerScriptService, bukan di tempat lain

### Problem: UI tidak muncul
**Solution**: Cek apakah RemoteEvents dibuat dengan benar di ReplicatedStorage

### Problem: Sound tidak ada
**Solution**: Pastikan SoundService bisa mengakses sound assets

### Problem: Admin tidak terdeteksi
**Solution**: Pastikan username tepat "ghawan2" (case sensitive)

## 📊 Performance Notes

- **Memory Efficient**: GUI di-destroy otomatis setelah digunakan
- **Network Optimized**: Menggunakan RemoteEvents untuk komunikasi
- **Cooldown Protection**: Mencegah spam dan lag
- **Cleanup**: Cooldown data dibersihkan saat player leave

## 🔒 Security Features

- **Username Validation**: Hanya username tertentu yang bisa akses
- **Input Sanitization**: Pesan divalidasi sebelum dikirim
- **Rate Limiting**: Cooldown system mencegah abuse
- **Error Handling**: Graceful error messages

## 🎉 Credits

**Created by**: GHAA SCRIPTER ROBLOX
**Version**: 1.0
**Date**: 2024

---

## 📝 Changelog

### v1.0 (Initial Release)
- ✅ Basic announcement system
- ✅ Admin restriction (ghawan2 only)
- ✅ Beautiful UI dengan animations
- ✅ Sound effects
- ✅ Cooldown system
- ✅ Error handling
- ✅ Auto cleanup

---

**🎮 Happy Gaming with GHAA SCRIPTER ROBLOX! 🎮**