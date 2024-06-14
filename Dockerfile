FROM nginxinc/nginx-unprivileged:1.25

COPY start.sh /usr/local/bin/

EXPOSE 8080
CMD ["start.sh"]
