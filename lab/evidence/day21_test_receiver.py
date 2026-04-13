from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length).decode("utf-8", errors="replace")
        print("\n===== REQUEST START =====")
        print(f"PATH: {self.path}")
        print("BODY:")
        print(body)
        print("===== REQUEST END =====\n")
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"ok")

server = HTTPServer(("0.0.0.0", 5001), Handler)
print("Listening on port 5001")
server.serve_forever()
