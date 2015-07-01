# 
# Dockerfile - vsftpd
#
# - Build
# docker build --rm -t vsftpd:3.0.2 /root/docker/production/vsftpd
#
# - Run
# docker run -d --name="vsftpd" -h "vsftpd" -p 20:20 -p 21:21 -v /home:/home -v /tmp:/tmp vsftpd:3.0.2
#
FROM     ubuntu:14.04
MAINTAINER Yongbok Kim <ruo91@yongbok.net>

# Repo
RUN sed -i 's/archive.ubuntu.com/kr.archive.ubuntu.com/g' /etc/apt/sources.list

# Last Package Update & Install
RUN apt-get update ; apt-get install -y vsftpd libpam-pwdfile apache2-utils supervisor
RUN mkdir /etc/vsftpd \
 && mkdir -p /var/run/vsftpd/empty \
 && useradd --home /home --gid nogroup -m --shell /bin/false vsftpd

ADD conf/vsftpd.pam                        /etc/pam.d/vsftpd
ADD conf/vsftpd.conf                       /etc/vsftpd.conf
ADD conf/vsftp_virtual_user.sh             /usr/bin/vsftpd_virtual_user
RUN chmod a+x /usr/bin/vsftpd_virtual_user

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Port
EXPOSE 20 21

# Daemon
CMD ["/usr/bin/supervisord"]