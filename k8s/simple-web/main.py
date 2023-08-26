from http.server import BaseHTTPRequestHandler, HTTPServer
import socket


class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()

            host_name = socket.gethostname()
            message = f"Host Name: {host_name}"

            self.wfile.write(message.encode())
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
    run(HTTPServer, SimpleHandler, port_number)
