import http.server
import socketserver

class CORSHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Añadir los encabezados CORS
        self.send_header('Access-Control-Allow-Origin', 'https://crud-angular-321e2.web.app')  # Permitir solo tu dominio
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.send_header('Access-Control-Allow-Credentials', 'true')  # Si necesitas enviar cookies, agrega esto
        super().end_headers()

    def do_OPTIONS(self):
        # Responder a la solicitud OPTIONS con el estado correcto
        self.send_response(200)
        self.end_headers()

def run(server_class=http.server.HTTPServer, handler_class=CORSHTTPRequestHandler):
    port = 8080
    server_address = ('', port)

    httpd = server_class(server_address, handler_class)
    print(f'Servidor corriendo en el puerto {port}')
    httpd.serve_forever()

if __name__ == "__main__":
    run()