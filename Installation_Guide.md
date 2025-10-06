# 🚀 GHAA SCRIPTER ROBLOX - Installation Guide

## ⚠️ PERBAIKAN ERROR OnClientEvent

Script sebelumnya memiliki error karena `OnClientEvent` hanya bisa digunakan di client. Sekarang sudah diperbaiki dengan memisahkan script menjadi **Server Script** dan **Client Script**.

## 📁 File yang Dibutuhkan

1. **`ServerScript_AnnouncementSystem.lua`** - Server Script
2. **`ClientScript_AnnouncementSystem.lua`** - Client Script

## 🔧 Cara Instalasi yang Benar

### Step 1: Server Script
1. Buka **ServerScriptService** di Roblox Studio
2. Buat **Script** baru
3. Copy seluruh kode dari `ServerScript_AnnouncementSystem.lua`
4. Paste ke dalam Script tersebut
5. Script akan otomatis membuat RemoteEvents di ReplicatedStorage

### Step 2: Client Script
1. Buka **StarterGui** di Roblox Studio
2. Buat **LocalScript** baru
3. Copy seluruh kode dari `ClientScript_AnnouncementSystem.lua`
4. Paste ke dalam LocalScript tersebut

**ATAU**

1. Buka **StarterPlayer** → **StarterPlayerScripts**
2. Buat **LocalScript** baru
3. Copy seluruh kode dari `ClientScript_AnnouncementSystem.lua`
4. Paste ke dalam LocalScript tersebut

## ✅ Verifikasi Instalasi

Setelah instalasi, cek apakah:

1. **ReplicatedStorage** memiliki:
   - `AnnouncementEvent` (RemoteEvent)
   - `AnnouncementRequest` (RemoteEvent)

2. **SoundService** memiliki:
   - `NotificationSound` (Sound)

3. **Output** menampilkan:
   ```
   🚀 GHAA SCRIPTER ROBLOX - Server Announcement System Loaded!
   🎨 GHAA SCRIPTER ROBLOX - Client Announcement System Loaded!
   ```

## 🎮 Testing

1. Masuk ke game sebagai username **"ghawan2"**
2. Ketik di chat: `!a Test announcement!`
3. Semua player harus melihat notifikasi yang menarik
4. Coba dengan username lain untuk test error message

## 🐛 Troubleshooting

### Problem: "OnClientEvent can only be used on the client"
**Solution**: Pastikan Client Script ada di StarterGui atau StarterPlayerScripts, bukan di ServerScriptService

### Problem: RemoteEvents tidak ditemukan
**Solution**: Pastikan Server Script sudah dijalankan terlebih dahulu

### Problem: UI tidak muncul
**Solution**: 
1. Cek apakah Client Script ada di tempat yang benar
2. Pastikan RemoteEvents sudah dibuat oleh Server Script
3. Cek Output untuk error messages

### Problem: Command tidak bekerja
**Solution**: Pastikan Server Script ada di ServerScriptService

## 📊 Struktur Script yang Benar

```
ServerScriptService/
└── AnnouncementSystem (Script)
    ├── Handles chat commands
    ├── Creates RemoteEvents
    ├── Validates admin access
    └── Manages cooldowns

StarterGui/ (atau StarterPlayerScripts/)
└── AnnouncementUI (LocalScript)
    ├── Listens to AnnouncementEvent
    ├── Creates beautiful UI
    ├── Handles animations
    └── Plays sound effects
```

## 🎯 Fitur yang Bekerja

✅ **Command System**: `!a (pesan)`  
✅ **Admin Restriction**: Hanya "ghawan2"  
✅ **Beautiful UI**: Gradient, animations, sound  
✅ **Cooldown System**: 5 detik antar announcement  
✅ **Error Handling**: Access denied untuk non-admin  
✅ **Auto Cleanup**: GUI di-destroy otomatis  

## 🚀 Ready to Use!

Script sekarang sudah **100% functional** dan siap digunakan! Tidak ada lagi error OnClientEvent karena sudah dipisahkan dengan benar.

---

**🎮 Happy Gaming with GHAA SCRIPTER ROBLOX! 🎮**