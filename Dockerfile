FROM dockurr/samba
WORKDIR /app

RUN apk --no-cache add fuse3
COPY --from=rclone/rclone --chmod=755 /usr/local/bin/rclone /usr/local/bin/rclone
COPY --chmod=755 start.sh /app/start.sh
COPY smb.conf /etc/samba/smb.conf

ENV TINI_SUBREAPER 1 # Need it for smb
ENV NAME "rclone"
ENV RW "false"

ENTRYPOINT [ "/app/start.sh" ]
