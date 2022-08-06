# Chrome image(set needed version from https://hub.docker.com/r/selenoid/chrome/tags)
FROM selenoid/chrome:104.0

# Set user root
USER root
 
# User under which container runs
ARG USER_NAME=selenium

# url to get personal and root certificates: http://testgost2012.cryptopro.ru/certsrv/
# certificates are valid for 3 months, it's necessary to periodically generate new ones
# Filename of the personal certificate and its password
ARG CERT_NAME=<personal_certificate.pfx>
ARG CERT_PWD=<certificate_password>

# Filename of the root certificate
ARG ROOT_CERT_NAME=<root.cer>

# List of trusted sites
ARG TRUSTED_SITES=""http://*.domain1.com" "http://*.domain2.com""

# CryptoPro CSP 5.0 activation key(if you have it)
#ARG CSP_LICENSE_KEY=<key>
 
ADD dist/ /tmp/dist/
ADD cert/ /tmp/cert/

# libgtk2.0-0 install
RUN apt update && apt-get install libgtk2.0-0 -y
 
# CryptoPro CSP 5.0 extract
RUN tar -zxvf /tmp/dist/linux-amd64_deb.tgz -C /tmp/dist/
 
# CryptoPro CSP 5.0 install
RUN /tmp/dist/linux-amd64_deb/install.sh
RUN dpkg -i /tmp/dist/linux-amd64_deb/cprocsp-rdr-gui-gtk-64_*
 
# Cades plugin extract
RUN tar -zxvf /tmp/dist/cades-linux-amd64.tar.gz -C /tmp/dist/
 
# Cades plugin install
RUN dpkg -i /tmp/dist/./cprocsp-pki-cades-*.deb
RUN dpkg -i /tmp/dist/./cprocsp-pki-plugin-*.deb
 
# License number (if you have license key, uncomment the following line and
# set your client key for arg $CSP_LICENSE_KEY and uncomment it !!!)
#RUN /opt/cprocsp/sbin/amd64/cpconfig -license -set $CSP_LICENSE_KEY
 
# License check
RUN /opt/cprocsp/sbin/amd64/cpconfig -license -view
 
# Switching to a "regular" user before installing certificates
USER $USER_NAME
 
# Root certificate install
RUN echo o | /opt/cprocsp/bin/amd64/certmgr -inst -file /tmp/cert/$ROOT_CERT_NAME -store uRoot
 
# Personal certificate install. -pin <password> is the password for the private key. If you need to add several certificates, then duplicate the line
RUN /opt/cprocsp/bin/amd64/certmgr -inst -pfx -file /tmp/cert/$CERT_NAME -pin $CERT_PWD -silent
 
# The command to remove the popup "license expires in less than 2 months".
RUN /opt/cprocsp/sbin/amd64/cpconfig -ini '\local\KeyDevices' -add long LicErrorLevel 4
 
# Switching to a root user
USER root
 
# Removing the alert "transition to a new algorithm in 2019"
RUN sed -i 's/\[Parameters\]/[Parameters]\nwarning_time_gen_2001=ll:131907744000000000\nwarning_time_sign_2001=ll:131907744000000000/g' /etc/opt/cprocsp/config64.ini
 
# Adding the address of the application to the trusted ones.
RUN /opt/cprocsp/sbin/amd64/cpconfig -ini "\config\cades\trustedsites" -add multistring "TrustedSites" $TRUSTED_SITES

# Switching to a "regular" user
USER $USER_NAME