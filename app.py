import http.server
import socketserver

class CORSHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Añadir los encabezados CORS
        self.send_header('Access-Control-Allow-Origin', '*')  # Permite todos los orígenes
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        super().end_headers()

def run(server_class=http.server.HTTPServer, handler_class=CORSHTTPRequestHandler):
    port = 8080
    server_address = ('', port)

    httpd = server_class(server_address, handler_class)
    print(f'Servidor corriendo en el puerto {port}')
    httpd.serve_forever()

if __name__ == "__main__":
    run()