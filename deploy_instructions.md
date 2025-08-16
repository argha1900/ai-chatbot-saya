(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF'
diff --git a/deploy_instructions.md b/deploy_instructions.md
--- a/deploy_instructions.md
+++ b/deploy_instructions.md
@@ -0,0 +1,220 @@
+# 🚀 Panduan Deployment AI Chatbot
+
+## 📋 Daftar Isi
+1. [Deploy ke GitHub](#deploy-ke-github)
+2. [Deploy ke Heroku](#deploy-ke-heroku)
+3. [Deploy ke Vercel](#deploy-ke-vercel)
+4. [Deploy ke Railway](#deploy-ke-railway)
+5. [Deploy ke Render](#deploy-ke-render)
+
+---
+
+## 🐙 Deploy ke GitHub
+
+### 1. Buat Repository Baru
+```bash
+# Inisialisasi git (jika belum)
+git init
+
+# Tambahkan semua file
+git add .
+
+# Commit pertama
+git commit -m "Initial commit: AI Chatbot"
+
+# Tambahkan remote repository
+git remote add origin https://github.com/USERNAME/ai-chatbot-saya.git
+
+# Push ke GitHub
+git push -u origin main
+```
+
+### 2. Setup GitHub Pages (Opsional)
+Untuk demo statis, Anda bisa menggunakan GitHub Pages dengan menambahkan file `index.html` di folder `docs/`.
+
+---
+
+## 🦸‍♂️ Deploy ke Heroku
+
+### 1. Install Heroku CLI
+```bash
+# Ubuntu/Debian
+sudo snap install heroku --classic
+
+# macOS
+brew tap heroku/brew && brew install heroku
+```
+
+### 2. Login ke Heroku
+```bash
+heroku login
+```
+
+### 3. Deploy
+```bash
+# Buat aplikasi Heroku
+heroku create ai-chatbot-saya
+
+# Deploy
+git push heroku main
+
+# Buka aplikasi
+heroku open
+```
+
+### 4. Environment Variables (Opsional)
+```bash
+heroku config:set FLASK_ENV=production
+```
+
+---
+
+## ⚡ Deploy ke Vercel
+
+### 1. Install Vercel CLI
+```bash
+npm install -g vercel
+```
+
+### 2. Login ke Vercel
+```bash
+vercel login
+```
+
+### 3. Deploy
+```bash
+# Deploy
+vercel
+
+# Untuk production
+vercel --prod
+```
+
+### 4. Setup Otomatis
+Vercel akan otomatis mendeteksi file `vercel.json` yang sudah ada.
+
+---
+
+## 🚂 Deploy ke Railway
+
+### 1. Buat Akun Railway
+Kunjungi [railway.app](https://railway.app) dan buat akun.
+
+### 2. Connect Repository
+1. Klik "New Project"
+2. Pilih "Deploy from GitHub repo"
+3. Pilih repository Anda
+
+### 3. Setup Environment
+Railway akan otomatis mendeteksi Python project dan menjalankan:
+```bash
+pip install -r requirements.txt
+python web_app.py
+```
+
+### 4. Custom Domain (Opsional)
+Railway menyediakan custom domain gratis.
+
+---
+
+## 🎨 Deploy ke Render
+
+### 1. Buat Akun Render
+Kunjungi [render.com](https://render.com) dan buat akun.
+
+### 2. Buat Web Service
+1. Klik "New +"
+2. Pilih "Web Service"
+3. Connect ke GitHub repository
+
+### 3. Setup Configuration
+- **Build Command**: `pip install -r requirements.txt`
+- **Start Command**: `python web_app.py`
+- **Environment**: Python 3
+
+### 4. Deploy
+Render akan otomatis deploy setiap kali ada push ke repository.
+
+---
+
+## 🔧 Konfigurasi Tambahan
+
+### Environment Variables
+Buat file `.env` untuk development:
+```env
+FLASK_ENV=development
+FLASK_DEBUG=True
+PORT=5000
+```
+
+### Production Settings
+Untuk production, edit `web_app.py`:
+```python
+if __name__ == '__main__':
+    port = int(os.environ.get('PORT', 5000))
+    app.run(host='0.0.0.0', port=port, debug=False)
+```
+
+### Custom Domain
+Setelah deploy, Anda bisa menambahkan custom domain di platform masing-masing.
+
+---
+
+## 📊 Monitoring
+
+### Logs
+- **Heroku**: `heroku logs --tail`
+- **Vercel**: Dashboard Vercel
+- **Railway**: Dashboard Railway
+- **Render**: Dashboard Render
+
+### Analytics
+Tambahkan Google Analytics atau tools monitoring lainnya.
+
+---
+
+## 🔒 Security
+
+### HTTPS
+Semua platform di atas menyediakan HTTPS otomatis.
+
+### Environment Variables
+Jangan commit file `.env` ke repository.
+
+### Rate Limiting
+Pertimbangkan menambahkan rate limiting untuk production.
+
+---
+
+## 🆘 Troubleshooting
+
+### Common Issues
+
+1. **Port Error**
+   ```python
+   port = int(os.environ.get('PORT', 5000))
+   ```
+
+2. **Dependencies Error**
+   ```bash
+   pip install -r requirements.txt
+   ```
+
+3. **Python Version**
+   Pastikan menggunakan Python 3.7+.
+
+### Support
+- Heroku: [Dev Center](https://devcenter.heroku.com)
+- Vercel: [Documentation](https://vercel.com/docs)
+- Railway: [Documentation](https://docs.railway.app)
+- Render: [Documentation](https://render.com/docs)
+
+---
+
+## 🎉 Selamat!
+
+Setelah deploy berhasil, AI Chatbot Anda akan tersedia online dan bisa diakses dari mana saja!
+
+**URL Aplikasi**: `https://your-app-name.herokuapp.com` (atau platform lainnya)
+
+**Demo**: Coba chat dengan AI chatbot Anda!
EOF
)