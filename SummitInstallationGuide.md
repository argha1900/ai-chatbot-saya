# 🏔️ GHAA SCRIPTER ROBLOX - Summit Title System

## 🎯 Deskripsi Sistem
Sistem title summit yang menarik dengan level progression! Setiap kali player menginjak finish line, title akan bertambah 1 level. Tapi harus respawn untuk bisa naik level lagi.

## ✨ Fitur Utama

### 🏁 Finish Line System
- **Deteksi Otomatis**: Sistem mendeteksi part bernama "FinishLine"
- **Level Progression**: Setiap finish = +1 level
- **Respawn Requirement**: Harus respawn untuk naik level lagi
- **Data Persistence**: Level tersimpan di DataStore

### 🏆 Title System (21 Levels)
- **Level 0**: 🏔️ DON'TOL
- **Level 1**: 🥉 PEMULA
- **Level 2**: 🥈 POKOKNYA
- **Level 3**: 🥇 KEREN
- **Level 4**: 💎 LEGEND
- **Level 5**: 👑 MASTER
- **Level 6**: 🌟 PRO
- **Level 7**: ⚡ ELITE
- **Level 8**: 🔥 CHAMPION
- **Level 9**: 💫 GRANDMASTER
- **Level 10**: 🏆 ULTIMATE
- **Level 11**: 🎯 PERFECT
- **Level 12**: 🚀 SUPREME
- **Level 13**: 💎 DIAMOND
- **Level 14**: 👑 ROYAL
- **Level 15**: 🌟 CELESTIAL
- **Level 16**: ⚡ THUNDER
- **Level 17**: 🔥 INFERNO
- **Level 18**: 💫 COSMIC
- **Level 19**: 🏆 OLYMPIAN
- **Level 20**: 🎯 DIVINE

### 🎨 UI Features
- **Main UI**: Menampilkan title dan level player
- **Leaderboard**: Ranking semua player
- **Notifications**: Level up dan finish notifications
- **Minimize/Maximize**: UI bisa di-minimize
- **Responsive**: Auto-adjust untuk berbagai ukuran layar

### 🔊 Sound Effects
- **Level Up Sound**: Electronic ping saat naik level
- **Finish Sound**: Bell sound saat finish
- **Volume Control**: Sound volume yang pas

## 📁 File yang Dibutuhkan

1. **`SummitTitleSystem.lua`** - Server Script
2. **`SummitClientScript.lua`** - Client Script

## 🔧 Cara Instalasi

### Step 1: Server Script
1. Buka **ServerScriptService** di Roblox Studio
2. Buat **Script** baru
3. Copy seluruh kode dari `SummitTitleSystem.lua`
4. Paste ke dalam Script tersebut

### Step 2: Client Script
1. Buka **StarterGui** di Roblox Studio
2. Buat **LocalScript** baru
3. Copy seluruh kode dari `SummitClientScript.lua`
4. Paste ke dalam LocalScript tersebut

### Step 3: Create Finish Line
1. Buat **Part** baru di Workspace
2. Rename part menjadi **"FinishLine"**
3. Set size dan position sesuai kebutuhan
4. Optional: Tambahkan material dan color yang menarik

## 🎮 Cara Kerja Sistem

### 1. Player Pertama Kali
- Player mulai dengan level 0 (🏔️ DON'TOL)
- Bisa menginjak finish line untuk naik level

### 2. Finish Line Touch
- Player menginjak finish line
- Jika bisa naik level → Level up notification
- Jika tidak bisa → Finish notification
- Harus respawn untuk bisa naik level lagi

### 3. Respawn System
- Player respawn → Bisa naik level lagi
- Level tersimpan di DataStore
- Data tidak hilang saat leave/join

### 4. UI Display
- Main UI menampilkan title dan level
- Leaderboard menampilkan ranking
- Notifications untuk level up dan finish

## ⚙️ Konfigurasi

### Mengubah Nama Finish Line:
```lua
local FINISH_PART_NAME = "YourFinishLineName"
```

### Mengubah Respawn Requirement:
```lua
local RESPAWN_REQUIRED = false -- Tidak perlu respawn
```

### Mengubah DataStore Name:
```lua
local SUMMIT_DATASTORE = "YourDataStoreName"
```

### Menambah/Mengubah Title:
```lua
local TITLE_NAMES = {
    [0] = "🏔️ DON'TOL",
    [1] = "🥉 PEMULA",
    -- Tambahkan title baru di sini
    [21] = "🌟 NEW TITLE"
}
```

## 🎨 Customization

### Mengubah Warna Title:
```lua
local TITLE_COLORS = {
    [0] = Color3.fromRGB(255, 0, 0), -- Merah
    [1] = Color3.fromRGB(0, 255, 0), -- Hijau
    -- Ubah warna sesuai keinginan
}
```

### Mengubah UI Position:
```lua
-- Main UI position
mainFrame.Position = UDim2.new(0, 20, 0, 20)

-- Leaderboard position  
mainFrame.Position = UDim2.new(1, -270, 0, 20)
```

### Mengubah Sound:
```lua
-- Level up sound
levelUpSound.SoundId = "rbxasset://sounds/your_sound.wav"

-- Finish sound
finishSound.SoundId = "rbxasset://sounds/your_sound.wav"
```

## 🐛 Troubleshooting

### Problem: Finish line tidak terdeteksi
**Solution**: 
1. Pastikan part bernama "FinishLine" (case sensitive)
2. Pastikan part ada di Workspace
3. Cek Output untuk pesan "Finish line found"

### Problem: Level tidak tersimpan
**Solution**: 
1. Pastikan DataStore enabled di game settings
2. Cek Output untuk error DataStore
3. Pastikan player memiliki internet connection

### Problem: UI tidak muncul
**Solution**: 
1. Pastikan Client Script ada di StarterGui
2. Cek Output untuk error messages
3. Pastikan RemoteEvents sudah dibuat

### Problem: Sound tidak ada
**Solution**: 
1. Pastikan SoundService bisa mengakses sound assets
2. Cek volume settings
3. Pastikan sound ID valid

## 📊 Performance Notes

- **DataStore**: Data tersimpan otomatis
- **Memory Efficient**: UI di-destroy setelah digunakan
- **Network Optimized**: Menggunakan RemoteEvents
- **Cleanup**: Data dibersihkan saat player leave

## 🔒 Security Features

- **Data Validation**: Level divalidasi sebelum disimpan
- **Error Handling**: Graceful error handling
- **Anti-Exploit**: Level tidak bisa diubah manual
- **DataStore Protection**: Pcall untuk mencegah error

## 🎉 Credits

**Created by**: GHAA SCRIPTER ROBLOX
**Version**: 1.0
**Date**: 2024

---

## 📝 Changelog

### v1.0 (Initial Release)
- ✅ Finish line detection system
- ✅ 21 levels dengan title menarik
- ✅ Respawn requirement system
- ✅ DataStore persistence
- ✅ Beautiful UI dengan animations
- ✅ Sound effects
- ✅ Leaderboard system
- ✅ Error handling

---

**🏔️ Happy Climbing with GHAA SCRIPTER ROBLOX! 🏔️**