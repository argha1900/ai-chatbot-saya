(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF'
diff --git a/ai_chatbot_simple.py b/ai_chatbot_simple.py
--- a/ai_chatbot_simple.py
+++ b/ai_chatbot_simple.py
@@ -0,0 +1,176 @@
+#!/usr/bin/env python3
+"""
+AI Chatbot Sederhana - Tanpa Dependencies Eksternal
+"""
+
+import random
+import json
+from datetime import datetime
+from typing import List, Dict, Any
+
+class AIChatbotSimple:
+    def __init__(self):
+        self.conversation_history = []
+        self.knowledge_base = {
+            "greetings": ["Halo!", "Hai!", "Selamat datang!", "Halo, ada yang bisa saya bantu?"],
+            "farewells": ["Sampai jumpa!", "Selamat tinggal!", "Sampai ketemu lagi!", "Bye!"],
+            "thanks": ["Sama-sama!", "Terima kasih kembali!", "Senang bisa membantu!"],
+            "weather": ["Cuaca hari ini cerah", "Sepertinya akan hujan", "Cuaca sedang dingin"],
+            "jokes": [
+                "Kenapa programmer suka kopi? Karena mereka butuh kafein untuk debug!",
+                "Apa bedanya programmer dan non-programmer? Programmer bisa bikin komputer kerja, non-programmer cuma bisa bikin komputer hang!",
+                "Kenapa AI tidak bisa bikin lelucon? Karena mereka belum punya sense of humor yang baik!"
+            ]
+        }
+        
+    def process_message(self, message: str) -> str:
+        """Process user message and return AI response"""
+        message = message.lower().strip()
+        
+        # Add to conversation history
+        self.conversation_history.append({
+            "user": message,
+            "timestamp": datetime.now().isoformat()
+        })
+        
+        # Simple keyword-based responses
+        if any(word in message for word in ["halo", "hai", "hello", "hi"]):
+            response = random.choice(self.knowledge_base["greetings"])
+        elif any(word in message for word in ["bye", "selamat tinggal", "sampai jumpa"]):
+            response = random.choice(self.knowledge_base["farewells"])
+        elif any(word in message for word in ["terima kasih", "thanks", "makasih"]):
+            response = random.choice(self.knowledge_base["thanks"])
+        elif any(word in message for word in ["cuaca", "weather"]):
+            response = random.choice(self.knowledge_base["weather"])
+        elif any(word in message for word in ["lelucon", "joke", "gurauan"]):
+            response = random.choice(self.knowledge_base["jokes"])
+        elif "siapa kamu" in message or "what are you" in message:
+            response = "Saya adalah AI chatbot yang dibuat khusus untuk Anda! Saya bisa membantu dengan berbagai hal."
+        elif "bisa apa" in message or "what can you do" in message:
+            response = "Saya bisa:\n- Menjawab salam\n- Memberikan lelucon\n- Membicarakan cuaca\n- Dan banyak lagi!"
+        elif "waktu" in message or "jam" in message or "time" in message:
+            current_time = datetime.now().strftime("%H:%M:%S")
+            response = f"Sekarang jam {current_time}"
+        elif "tanggal" in message or "date" in message:
+            current_date = datetime.now().strftime("%d/%m/%Y")
+            response = f"Hari ini tanggal {current_date}"
+        else:
+            response = self.generate_smart_response(message)
+        
+        # Add AI response to history
+        self.conversation_history.append({
+            "ai": response,
+            "timestamp": datetime.now().isoformat()
+        })
+        
+        return response
+    
+    def generate_smart_response(self, message: str) -> str:
+        """Generate more intelligent responses based on message content"""
+        # Simple pattern matching
+        if "?" in message:
+            return "Pertanyaan yang menarik! Saya masih belajar, tapi saya akan berusaha membantu sebaik mungkin."
+        elif len(message) < 5:
+            return "Pesan Anda terlalu pendek. Bisa dijelaskan lebih detail?"
+        elif len(message) > 100:
+            return "Wah, pesan yang panjang! Saya sudah membaca semuanya. Ada yang bisa saya bantu?"
+        else:
+            responses = [
+                "Menarik sekali! Bisa dijelaskan lebih lanjut?",
+                "Saya mengerti. Ada hal lain yang ingin Anda tanyakan?",
+                "Terima kasih sudah berbagi dengan saya!",
+                "Saya akan mengingat informasi ini.",
+                "Bagus sekali! Ada yang bisa saya bantu lagi?"
+            ]
+            return random.choice(responses)
+    
+    def get_conversation_history(self) -> List[Dict[str, Any]]:
+        """Get conversation history"""
+        return self.conversation_history
+    
+    def clear_history(self):
+        """Clear conversation history"""
+        self.conversation_history = []
+    
+    def add_knowledge(self, category: str, responses: List[str]):
+        """Add new knowledge to the AI"""
+        if category not in self.knowledge_base:
+            self.knowledge_base[category] = []
+        self.knowledge_base[category].extend(responses)
+    
+    def get_stats(self) -> Dict[str, Any]:
+        """Get AI statistics"""
+        return {
+            "total_conversations": len(self.conversation_history) // 2,
+            "knowledge_categories": len(self.knowledge_base),
+            "total_responses": len([msg for msg in self.conversation_history if "ai" in msg]),
+            "created_at": datetime.now().isoformat()
+        }
+
+def run_demo():
+    """Demo sederhana AI chatbot"""
+    print("🤖 Demo AI Chatbot Sederhana")
+    print("=" * 50)
+    
+    ai = AIChatbotSimple()
+    
+    demo_messages = [
+        "Halo",
+        "Siapa kamu?",
+        "Bisa apa?",
+        "Lelucon",
+        "Jam berapa sekarang?",
+        "Terima kasih",
+        "Selamat tinggal"
+    ]
+    
+    for message in demo_messages:
+        print(f"\n👤 Anda: {message}")
+        response = ai.process_message(message)
+        print(f"🤖 AI: {response}")
+    
+    print("\n" + "=" * 50)
+    print("📊 Statistik:")
+    stats = ai.get_stats()
+    for key, value in stats.items():
+        print(f"  {key}: {value}")
+
+def run_interactive():
+    """Run interactive chat"""
+    print("🤖 AI Chatbot Sederhana")
+    print("=" * 50)
+    print("Ketik 'quit' untuk keluar")
+    print("-" * 50)
+    
+    ai = AIChatbotSimple()
+    
+    while True:
+        try:
+            user_input = input("👤 Anda: ")
+            if user_input.lower() in ['quit', 'exit', 'keluar']:
+                print("🤖 AI: Sampai jumpa! 👋")
+                break
+            
+            response = ai.process_message(user_input)
+            print(f"🤖 AI: {response}")
+            
+        except KeyboardInterrupt:
+            print("\n🤖 AI: Sampai jumpa! 👋")
+            break
+        except EOFError:
+            print("\n🤖 AI: Sampai jumpa! 👋")
+            break
+
+# Example usage
+if __name__ == "__main__":
+    import sys
+    
+    if len(sys.argv) > 1:
+        if sys.argv[1] == "demo":
+            run_demo()
+        elif sys.argv[1] == "interactive":
+            run_interactive()
+        else:
+            print("Usage: python3 ai_chatbot_simple.py [demo|interactive]")
+    else:
+        run_interactive()
EOF
)