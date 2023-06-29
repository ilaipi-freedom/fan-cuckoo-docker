FROM tianon/qemu

WORKDIR /home/cuckoo

RUN rm -f /etc/apt/sources.list.d/debian.sources

RUN echo "\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware\n\
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware\n\
deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware\n\
deb https://mirrors.ustc.edu.cn/debian/ buster main contrib non-free \n\
deb https://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free \n\
deb https://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free \n\
deb https://mirrors.ustc.edu.cn/debian-security/ buster/updates main contrib non-free \n\
" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y python python-pip python-dev libffi-dev libssl-dev
RUN apt-get install -y python-virtualenv python-setuptools
RUN apt-get install -y libjpeg-dev zlib1g-dev swig tcpdump apparmor-utils
# RUN apt-get install -y libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
# ADD https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh ./anaconda.sh

RUN pip install -U pip setuptools
RUN pip install -U cuckoo

RUN useradd -ms /bin/bash cuckoo && \
  usermod -aG sudo cuckoo
RUN chmod -R 777 /home/cuckoo

USER cuckoo

CMD ["tail", "-f", "/dev/null"]
