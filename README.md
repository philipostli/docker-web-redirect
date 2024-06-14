# Docker-Web-Redirect #
![GitHub repo size](https://img.shields.io/github/repo-size/philipostli/docker-web-redirect)
![GitHub Repo stars](https://img.shields.io/github/stars/philipostli/docker-web-redirect)
![Docker Pulls](https://img.shields.io/docker/pulls/philipostli/docker-web-redirect)
![Docker Stars](https://img.shields.io/docker/stars/philipostli/docker-web-redirect)

This project is forked from [MorbZ/docker-web-redirect](https://github.com/MorbZ/docker-web-redirect). With main goal to run as non root user in OpenShift environments, and work as Android Link redirector for https: links in e-mails.

This Docker container listens on port 8080 and redirects all web traffic to the given target domain/URL. It is running as a non-root user so it can be deployed in OpenShift without privileges. It can be used for Android App Linking from e-mails as most mail clients do not allow schemas other than https: or mailto: etc.

## Features ##
- Lightweight: Uses only ~2 MB RAM on Linux
- Keeps the URL path and GET parameters
- Permanent or temporary redirect

## Usage ##
### Docker run ###
The target domain/URL is set by the `REDIRECT_TARGET` environment variable.  
Possible redirect targets include domains (`https://mydomain.net`), paths (`https://mydomain.net/my_page`) or specific protocols (`myapp:com.exampleapp?token=123`).  

**Example:** `$ docker run --rm -d -e REDIRECT_TARGET=mydomain.net REDIRECT_TYPE=redirect -p 8080:8080 philipostli/docker-web-redirect`

### Paths are retained ###
The URL path and GET parameters are retained by default. That means that a request to `http://myolddomain.net/index.php?page=2` will be redirected to `http://mydomain.net/index.php?page=2` when `REDIRECT_TARGET=mydomain.net` is set. If you do not want to retain the path and GET parameters, set the environment variable `RETAIN_PATH` to `false`.

### Permanent redirects ###
Redirects are, by default, permanent (HTTP status code 301). That means browsers will cache the redirect and will go directly to the new site on further requests. Also search engines will recognize the new domain and change their URLs. To make redirects temporary (HTTP status code 302), e.g. for site maintenance, set the environment variable `REDIRECT_TYPE` to `redirect`.

## Docker Compose ##
This image can be combined with the [jwilder nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/). A sample docker-compose file that redirects `myolddomain.net` to `mydomain.net` could look like this:

```yaml
version: '3'
services:
  redirect:
    image: philipostli/docker-web-redirect
    restart: always
    environment:
      - VIRTUAL_HOST=myolddomain.net
      - REDIRECT_TARGET=mydomain.net
```
