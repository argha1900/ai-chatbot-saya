(cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF'
diff --git a/Procfile b/Procfile
--- a/Procfile
+++ b/Procfile
@@ -0,0 +1,1 @@
+web: python web_app.py
EOF
)