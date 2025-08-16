(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF'
diff --git a/test_ai.py b/test_ai.py
--- a/test_ai.py
+++ b/test_ai.py
@@ -0,0 +1,123 @@
+#!/usr/bin/env python3
+"""
+Test file untuk AI Chatbot
+"""
+
+import unittest
+from ai_chatbot import AIChatbot
+from datetime import datetime
+
+class TestAIChatbot(unittest.TestCase):
+    
+    def setUp(self):
+        """Setup untuk setiap test"""
+        self.ai = AIChatbot()
+    
+    def test_greeting(self):
+        """Test respons salam"""
+        response = self.ai.process_message("Halo")
+        self.assertIn(response, self.ai.knowledge_base["greetings"])
+    
+    def test_farewell(self):
+        """Test respons perpisahan"""
+        response = self.ai.process_message("Selamat tinggal")
+        self.assertIn(response, self.ai.knowledge_base["farewells"])
+    
+    def test_thanks(self):
+        """Test respons terima kasih"""
+        response = self.ai.process_message("Terima kasih")
+        self.assertIn(response, self.ai.knowledge_base["thanks"])
+    
+    def test_joke(self):
+        """Test respons lelucon"""
+        response = self.ai.process_message("Lelucon")
+        self.assertIn(response, self.ai.knowledge_base["jokes"])
+    
+    def test_weather(self):
+        """Test respons cuaca"""
+        response = self.ai.process_message("Cuaca")
+        self.assertIn(response, self.ai.knowledge_base["weather"])
+    
+    def test_time(self):
+        """Test respons waktu"""
+        response = self.ai.process_message("Jam berapa sekarang?")
+        self.assertIn("jam", response.lower())
+    
+    def test_date(self):
+        """Test respons tanggal"""
+        response = self.ai.process_message("Tanggal berapa hari ini?")
+        self.assertIn("tanggal", response.lower())
+    
+    def test_who_are_you(self):
+        """Test respons siapa kamu"""
+        response = self.ai.process_message("Siapa kamu?")
+        self.assertIn("AI chatbot", response)
+    
+    def test_what_can_you_do(self):
+        """Test respons bisa apa"""
+        response = self.ai.process_message("Bisa apa?")
+        self.assertIn("bisa", response.lower())
+    
+    def test_conversation_history(self):
+        """Test riwayat percakapan"""
+        self.ai.process_message("Test message")
+        history = self.ai.get_conversation_history()
+        self.assertGreater(len(history), 0)
+    
+    def test_clear_history(self):
+        """Test hapus riwayat"""
+        self.ai.process_message("Test message")
+        self.ai.clear_history()
+        history = self.ai.get_conversation_history()
+        self.assertEqual(len(history), 0)
+    
+    def test_add_knowledge(self):
+        """Test tambah pengetahuan"""
+        self.ai.add_knowledge("test_category", ["Test response"])
+        self.assertIn("test_category", self.ai.knowledge_base)
+        self.assertIn("Test response", self.ai.knowledge_base["test_category"])
+    
+    def test_stats(self):
+        """Test statistik"""
+        stats = self.ai.get_stats()
+        self.assertIn("total_conversations", stats)
+        self.assertIn("knowledge_categories", stats)
+        self.assertIn("total_responses", stats)
+        self.assertIn("created_at", stats)
+
+def run_demo():
+    """Demo sederhana AI chatbot"""
+    print("🤖 Demo AI Chatbot")
+    print("=" * 50)
+    
+    ai = AIChatbot()
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
+if __name__ == "__main__":
+    import sys
+    
+    if len(sys.argv) > 1 and sys.argv[1] == "demo":
+        run_demo()
+    else:
+        # Jalankan unit tests
+        unittest.main(verbosity=2)
EOF
)