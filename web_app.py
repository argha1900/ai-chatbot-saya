(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF'
diff --git a/web_app.py b/web_app.py
--- a/web_app.py
+++ b/web_app.py
@@ -0,0 +1,54 @@
+from flask import Flask, render_template, request, jsonify
+from ai_chatbot import AIChatbot
+import json
+
+app = Flask(__name__)
+ai = AIChatbot()
+
+@app.route('/')
+def home():
+    return render_template('index.html')
+
+@app.route('/chat', methods=['POST'])
+def chat():
+    data = request.get_json()
+    user_message = data.get('message', '')
+    
+    if not user_message:
+        return jsonify({'error': 'Pesan tidak boleh kosong'}), 400
+    
+    # Get AI response
+    ai_response = ai.process_message(user_message)
+    
+    return jsonify({
+        'response': ai_response,
+        'timestamp': ai.conversation_history[-1]['timestamp']
+    })
+
+@app.route('/history')
+def get_history():
+    return jsonify(ai.get_conversation_history())
+
+@app.route('/clear', methods=['POST'])
+def clear_history():
+    ai.clear_history()
+    return jsonify({'message': 'Riwayat percakapan berhasil dihapus'})
+
+@app.route('/stats')
+def get_stats():
+    return jsonify(ai.get_stats())
+
+@app.route('/add_knowledge', methods=['POST'])
+def add_knowledge():
+    data = request.get_json()
+    category = data.get('category', '')
+    responses = data.get('responses', [])
+    
+    if not category or not responses:
+        return jsonify({'error': 'Kategori dan respons diperlukan'}), 400
+    
+    ai.add_knowledge(category, responses)
+    return jsonify({'message': f'Pengetahuan baru ditambahkan ke kategori: {category}'})
+
+if __name__ == '__main__':
+    app.run(debug=True, host='0.0.0.0', port=5000)
EOF
)