(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF'
diff --git a/static/js/script.js b/static/js/script.js
--- a/static/js/script.js
+++ b/static/js/script.js
@@ -0,0 +1,212 @@
+document.addEventListener('DOMContentLoaded', function() {
+    const chatForm = document.getElementById('chatForm');
+    const messageInput = document.getElementById('messageInput');
+    const chatMessages = document.getElementById('chatMessages');
+    const clearBtn = document.getElementById('clearBtn');
+    const statsBtn = document.getElementById('statsBtn');
+    const statsModal = document.getElementById('statsModal');
+    const closeModal = document.querySelector('.close');
+    const statsContent = document.getElementById('statsContent');
+
+    // Set current time for initial message
+    document.getElementById('currentTime').textContent = new Date().toLocaleTimeString('id-ID');
+
+    // Chat form submission
+    chatForm.addEventListener('submit', async function(e) {
+        e.preventDefault();
+        
+        const message = messageInput.value.trim();
+        if (!message) return;
+
+        // Add user message to chat
+        addMessage(message, 'user');
+        messageInput.value = '';
+
+        // Show typing indicator
+        showTypingIndicator();
+
+        try {
+            // Send message to AI
+            const response = await fetch('/chat', {
+                method: 'POST',
+                headers: {
+                    'Content-Type': 'application/json',
+                },
+                body: JSON.stringify({ message: message })
+            });
+
+            const data = await response.json();
+            
+            // Remove typing indicator
+            removeTypingIndicator();
+
+            if (response.ok) {
+                // Add AI response to chat
+                addMessage(data.response, 'ai');
+            } else {
+                addMessage('Maaf, terjadi kesalahan. Silakan coba lagi.', 'ai');
+            }
+        } catch (error) {
+            removeTypingIndicator();
+            addMessage('Maaf, terjadi kesalahan koneksi. Silakan coba lagi.', 'ai');
+        }
+    });
+
+    // Add message to chat
+    function addMessage(text, sender) {
+        const messageDiv = document.createElement('div');
+        messageDiv.className = `message ${sender}-message`;
+        
+        const avatar = document.createElement('div');
+        avatar.className = 'message-avatar';
+        
+        if (sender === 'ai') {
+            avatar.innerHTML = '<i class="fas fa-robot"></i>';
+        } else {
+            avatar.innerHTML = '<i class="fas fa-user"></i>';
+        }
+
+        const content = document.createElement('div');
+        content.className = 'message-content';
+        
+        const messageText = document.createElement('div');
+        messageText.className = 'message-text';
+        messageText.textContent = text;
+        
+        const messageTime = document.createElement('div');
+        messageTime.className = 'message-time';
+        messageTime.textContent = new Date().toLocaleTimeString('id-ID');
+        
+        content.appendChild(messageText);
+        content.appendChild(messageTime);
+        
+        messageDiv.appendChild(avatar);
+        messageDiv.appendChild(content);
+        
+        chatMessages.appendChild(messageDiv);
+        
+        // Scroll to bottom
+        chatMessages.scrollTop = chatMessages.scrollHeight;
+    }
+
+    // Show typing indicator
+    function showTypingIndicator() {
+        const typingDiv = document.createElement('div');
+        typingDiv.className = 'message ai-message typing-indicator';
+        typingDiv.id = 'typingIndicator';
+        
+        const avatar = document.createElement('div');
+        avatar.className = 'message-avatar';
+        avatar.innerHTML = '<i class="fas fa-robot"></i>';
+        
+        const content = document.createElement('div');
+        content.className = 'message-content';
+        content.innerHTML = '<div class="message-text">AI sedang mengetik...</div>';
+        
+        typingDiv.appendChild(avatar);
+        typingDiv.appendChild(content);
+        
+        chatMessages.appendChild(typingDiv);
+        chatMessages.scrollTop = chatMessages.scrollHeight;
+    }
+
+    // Remove typing indicator
+    function removeTypingIndicator() {
+        const typingIndicator = document.getElementById('typingIndicator');
+        if (typingIndicator) {
+            typingIndicator.remove();
+        }
+    }
+
+    // Clear chat history
+    clearBtn.addEventListener('click', async function() {
+        if (confirm('Apakah Anda yakin ingin menghapus semua riwayat percakapan?')) {
+            try {
+                const response = await fetch('/clear', {
+                    method: 'POST'
+                });
+                
+                if (response.ok) {
+                    // Clear chat messages except the first welcome message
+                    const messages = chatMessages.querySelectorAll('.message');
+                    for (let i = 1; i < messages.length; i++) {
+                        messages[i].remove();
+                    }
+                    
+                    // Show success message
+                    addMessage('Riwayat percakapan berhasil dihapus!', 'ai');
+                }
+            } catch (error) {
+                addMessage('Gagal menghapus riwayat percakapan.', 'ai');
+            }
+        }
+    });
+
+    // Show statistics
+    statsBtn.addEventListener('click', async function() {
+        try {
+            const response = await fetch('/stats');
+            const stats = await response.json();
+            
+            statsContent.innerHTML = `
+                <div style="text-align: center;">
+                    <div style="margin-bottom: 20px;">
+                        <i class="fas fa-chart-line" style="font-size: 3rem; color: #667eea;"></i>
+                    </div>
+                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
+                        <div style="background: #f8f9fa; padding: 15px; border-radius: 10px;">
+                            <h4 style="color: #667eea; margin-bottom: 5px;">Total Percakapan</h4>
+                            <p style="font-size: 1.5rem; font-weight: bold;">${stats.total_conversations}</p>
+                        </div>
+                        <div style="background: #f8f9fa; padding: 15px; border-radius: 10px;">
+                            <h4 style="color: #667eea; margin-bottom: 5px;">Total Respons</h4>
+                            <p style="font-size: 1.5rem; font-weight: bold;">${stats.total_responses}</p>
+                        </div>
+                    </div>
+                    <div style="background: #f8f9fa; padding: 15px; border-radius: 10px;">
+                        <h4 style="color: #667eea; margin-bottom: 5px;">Kategori Pengetahuan</h4>
+                        <p style="font-size: 1.5rem; font-weight: bold;">${stats.knowledge_categories}</p>
+                    </div>
+                    <div style="margin-top: 20px; font-size: 0.9rem; color: #666;">
+                        Dibuat pada: ${new Date(stats.created_at).toLocaleString('id-ID')}
+                    </div>
+                </div>
+            `;
+            
+            statsModal.style.display = 'block';
+        } catch (error) {
+            statsContent.innerHTML = '<p>Gagal memuat statistik.</p>';
+            statsModal.style.display = 'block';
+        }
+    });
+
+    // Close modal
+    closeModal.addEventListener('click', function() {
+        statsModal.style.display = 'none';
+    });
+
+    // Close modal when clicking outside
+    window.addEventListener('click', function(e) {
+        if (e.target === statsModal) {
+            statsModal.style.display = 'none';
+        }
+    });
+
+    // Enter key to send message
+    messageInput.addEventListener('keypress', function(e) {
+        if (e.key === 'Enter' && !e.shiftKey) {
+            e.preventDefault();
+            chatForm.dispatchEvent(new Event('submit'));
+        }
+    });
+
+    // Auto-focus on input
+    messageInput.focus();
+
+    // Add some example messages for demonstration
+    setTimeout(() => {
+        if (chatMessages.children.length === 1) {
+            addMessage('Coba tanyakan saya tentang lelucon, cuaca, atau waktu!', 'ai');
+        }
+    }, 2000);
+});
EOF
)