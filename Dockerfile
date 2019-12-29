FROM buildpack-deps:18.04-scm
COPY entrypoint.sh /entrypoint.sh
COPY merge.sh /merge.sh
ENTRYPOINT ["/entrypoint.sh"]
