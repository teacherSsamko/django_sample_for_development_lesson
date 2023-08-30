from http.server import BaseHTTPRequestHandler, HTTPServer
import socket


class SimpleHandler(BaseHTTPRequestHandler):
    request = 0

    def do_GET(self):
        if self.path == "/" and SimpleHandler.request < 5:
            self.send_response(200)
            SimpleHandler.request += 1
            self.send_header("Content-type", "text/html")
            self.end_headers()

            host_name = socket.gethostname()
            message = f"Host Name: {host_name} / v=unhealthy / Request: {SimpleHandler.request} /\n"

            self.wfile.write(message.encode())
        elif SimpleHandler.request >= 5:
            self.send_response(500)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write("Too many requests".encode())
        else:
            self.send_response(404)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write("Not Found".encode())


def run(server_class, handler_class, port):
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    print(f"Server started on port {port}")
    httpd.serve_forever()


if __name__ == "__main__":
    port_number = 8000
    print("Simple Web Server starting...")
    run(HTTPServer, SimpleHandler, port_number)
