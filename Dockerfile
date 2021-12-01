FROM node:17

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
