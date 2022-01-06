FROM ubuntu:21.10
MAINTAINER pmerlin1 <mosen@users.noreply.github.com>

# Install OpenJDK 8
RUN apt-get update && apt-get install -y openjdk-11-jre

# Install JAMF-IM package, but don't use interactive configuration
ADD jamf-im-2.2.2-0_lps.deb /tmp/jamf-im-2.2.2-0_lps.deb
RUN dpkg --unpack /tmp/jamf-im-2.2.2-0_lps.deb

COPY ./etc/jamf-im /etc/jamf-im

RUN mkdir -p /var/lib/jamf-im/felix-cache && chown -R jamfservice /var/lib/jamf-im/felix-cache
RUN touch /var/log/jamf-im.log && chown jamfservice /var/log/jamf-im.log
RUN touch /var/log/jamf-im-launcher.log && chown jamfservice /var/log/jamf-im-launcher.log
RUN chown -R jamfservice /usr/share/jamf-im
RUN chown -R jamfservice /etc/jamf-im

ADD jamf-im.sh /usr/bin/jamf-im.sh
RUN chmod +x /usr/bin/jamf-im.sh


# Enrollment variables
ENV JSAM_HOSTNAME="" JSS_URL="" JSS_USERNAME="" JSS_PASSWORD=""
USER jamfservice
ENTRYPOINT ["/usr/bin/jamf-im.sh"]
