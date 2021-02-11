FROM registry.access.redhat.com/ubi8/ubi:latest

ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

ADD https://www.python.org/ftp/python/3.8.7/Python-3.8.7.tgz /opt

ADD https://files.pythonhosted.org/packages/fe/ef/60d7ba03b5c442309ef42e7d69959f73aacccd0d86008362a681c4698e83/pip-21.0.1-py3-none-any.whl /opt

RUN dnf upgrade -y && \
	dnf install -y make gcc openssl-devel bzip2-devel libffi-devel xz-devel sqlite-devel && \
	cd /opt && \
	tar -xzvf Python-3.8.7.tgz && \
	rm -f Python-3.8.7.tgz && \
	cd Python-3.8.7 && \
	./configure --enable-optimizations && \
	make altinstall && \
	ln -s /opt/Python-3.8.7/python /usr/bin/python3 && \
	ln -s /opt/Python-3.8.7/python /usr/bin/python && \
	python3 -m pip install --no-index --upgrade /opt/pip-21.0.1-py3-none-any.whl && \
	mv /usr/bin/python3 /usr/bin/python36 && \
	ln -s /opt/Python-3.8.7/python /usr/bin/python3 && \
	rm -f pip-21.0.1-py3-none-any.whl && \
	dnf -y remove gcc make openssl-devel bzip2-devel libffi-devel xz-devel && \
	find /opt/Python-3.8.7 -name "*.pem" -o -name "*.key" | xargs rm -f && \
	find /usr/local/lib/python3.8/test -name "*.pem" -o -name "*.key" | xargs rm -f && \
	dnf clean all && \
	rm -rf /var/cache/dnf

# add centos repos for installing powertools and gdal deps
ADD ./centos.repo /etc/yum.repos.d/centos.repo

ADD ./RPM-GPG-KEY-CentOS-Official /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Official

ADD ./requirements.txt requirements.txt

# for cryptography -___-
RUN dnf install --disableplugin=subscription-manager -y \
		rust &&\
	pip3 install --no-cache-dir -r requirements.txt && \
  	dnf remove rust -y &&\
  	dnf clean all &&\
  	rm -rf /var/cache/dnf

WORKDIR /app/

ADD ./wait-for-it.sh /wait-for-it.sh

EXPOSE 8080

CMD ["flask", "run", "--port", "8080", "--host", "0.0.0.0"]
