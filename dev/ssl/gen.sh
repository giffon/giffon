openssl req -x509 -newkey rsa:2048 -keyout keytmp.pem -out cert.pem -days 3650 -subj '/CN=localhost' -nodes
openssl rsa -in keytmp.pem -out key.pem