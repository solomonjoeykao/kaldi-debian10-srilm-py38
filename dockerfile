FROM kaldiasr/kaldi:cpu-debian10-2023-05-08 AS base
 
COPY ./srilm.tgz /opt/kaldi/tools/
RUN apt-get update && apt-get -y install sudo
RUN sudo apt-get install -y --no-install-recommends gawk
RUN cd /opt/kaldi/tools && ./install_srilm.sh && . ./env.sh
 
FROM base AS python
ADD ./Python-3.8.16.tar .
RUN apt-get update && apt-get -y install --no-install-recommends build-essential python-dev python-setuptools python-smbus \
    libncursesw5-dev libgdbm-dev libc6-dev zlib1g-dev libsqlite3-dev tk-dev \
    libssl-dev openssl libffi-dev \
    libaprutil1=1.6.1-4+deb10u1 libgnutls30=3.6.7-4+deb10u10 libtiff5=4.1.0+git191117-2~deb10u7
RUN cd Python-3.8.16 && ./configure && make && make install
RUN pip3.8 install -U setuptools
RUN python3.8 --version
 
FROM python AS final
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*}
