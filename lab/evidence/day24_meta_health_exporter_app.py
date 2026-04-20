from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

def check_url(url):
    try:
        result = subprocess.run(
            ["curl", "-s", "-o", "/dev/null", "-w", "%{http_code}", url],
            capture_output=True,
            text=True,
            timeout=10,
            check=False,
        )
        code = result.stdout.strip()
        return 1 if code in ("200", "302", "501") else 0
    except Exception:
        return 0

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path != "/metrics":
            self.send_response(404)
            self.end_headers()
            return

        prometheus_ok = check_url("http://prometheus:9090/-/healthy")
        alertmanager_ok = check_url("http://alertmanager:9093/-/healthy")
        grafana_ok = check_url("http://grafana:3000")
        receiver_ok = check_url("http://test-receiver:5001")

        body = f"""# HELP meta_prometheus_up Prometheus local health
# TYPE meta_prometheus_up gauge
meta_prometheus_up {prometheus_ok}
# HELP meta_alertmanager_up Alertmanager local health
# TYPE meta_alertmanager_up gauge
meta_alertmanager_up {alertmanager_ok}
# HELP meta_grafana_up Grafana local health
# TYPE meta_grafana_up gauge
meta_grafana_up {grafana_ok}
# HELP meta_test_receiver_up Test receiver local health
# TYPE meta_test_receiver_up gauge
meta_test_receiver_up {receiver_ok}
"""
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; version=0.0.4")
        self.end_headers()
        self.wfile.write(body.encode("utf-8"))

print("Listening on port 9911", flush=True)
server = HTTPServer(("0.0.0.0", 9911), Handler)
server.serve_forever()
