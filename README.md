<p align="center"><img src="https://user-images.githubusercontent.com/4303310/43110007-acdfd638-8efa-11e8-9bf1-33432cbdef04.png" /></p>

> HTTP caching between our servers and S3 so that images were only downloaded once from S3.

####Usage
```bash
docker run -p 8085:8085 -v /path/to/nginx.conf:/nginx.conf anmolnagpal/s3-nginx-proxy 
```

#####Example nginx.conf file:

```
worker_processes 2;
pid /run/nginx.pid;
daemon off;

events {
	worker_connections 768;
}

http {
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	server_names_hash_bucket_size 64;

	include /usr/local/nginx/conf/mime.types;
	default_type application/octet-stream;

	access_log /dev/stdout upstreamlog;
	error_log  /dev/stderr;

	gzip on;
	gzip_disable "msie6";
	gzip_http_version 1.1;
	gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    proxy_cache_lock on;
    proxy_cache_lock_timeout 60s;
    proxy_cache_path /data/cache levels=1:2 keys_zone=s3cache:10m max_size=30g;

    server {
        listen     8085;

        location / {
            proxy_pass https://bucket-name.s3.amazonaws.com;

            aws_access_key s3-access-key;
            aws_secret_key s3-secret-key;
            s3_bucket bucket-name;

            proxy_set_header Authorization $s3_auth_token;
            proxy_set_header x-amz-date $aws_date;

            proxy_cache        s3_cache;
            proxy_cache_valid  200 302  24h;
        }
    }
}
```
- Refrence :
    - https://stackoverflow.com/questions/44639182/nginx-proxy-amazon-s3-resources

## 👬 Contribution
- Open pull request with improvements
- Discuss ideas in issues
- Reach out with any feedback [![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/anmol_nagpal.svg?style=social&label=Follow%20%40anmol_nagpal)](https://twitter.com/anmol_nagpal)
