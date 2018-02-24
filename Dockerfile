FROM base/archlinux

RUN echo $'\n[archlinuxfr]\n\
SigLevel = Never\n\
Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf

RUN pacman -Sy
RUN pacman -S --noconfirm base-devel sudo yaourt python

RUN useradd -m -s /bin/bash -d /home/build build 
RUN echo "build ALL=NOPASSWD: ALL" >> /etc/sudoers

CMD ["/bin/bash"]
