from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import json

class WebhookHandler(BaseHTTPRequestHandler):

    def do_POST(self):

        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)

        data = json.loads(body)

        for alert in data["alerts"]:
            if alert["labels"]["alertname"] == "NodeExporterDown":
                subprocess.run(["./automation/scripts/restart_node_exporter.sh"])

        self.send_response(200)
        self.end_headers()

server = HTTPServer(("0.0.0.0", 5001), WebhookHandler)
server.serve_forever()
