FROM plabedan/gentoo
MAINTAINER Martin Liška

RUN emerge --sync
RUN emerge zip unzip strace

# build GCC
WORKDIR /abuild/
RUN wget --no-check-certificate https://github.com/marxin/gcc/archive/docker.zip -O docker.zip
RUN unzip docker.zip
WORKDIR gcc-docker
RUN mkdir objdir 
WORKDIR objdir

RUN ../configure --prefix=/usr --bindir=/usr/x86_64-pc-linux-gnu/gcc-bin/5.0.0 --includedir=/usr/lib/gcc/x86_64-pc-linux-gnu/5.0.0/include --datadir=/usr/share/gcc-data/x86_64-pc-linux-gnu/5.0.0 --mandir=/usr/share/gcc-data/x86_64-pc-linux-gnu/5.0.0/man --infodir=/usr/share/gcc-data/x86_64-pc-linux-gnu/5.0.0/info --with-gxx-include-dir=/usr/lib/gcc/x86_64-pc-linux-gnu/5.0.0/include/g++-v4 --host=x86_64-pc-linux-gnu --build=x86_64-pc-linux-gnu --disable-altivec --disable-fixed-point --without-cloog --without-ppl --enable-lto --enable-nls --without-included-gettext --with-system-zlib --enable-obsolete --disable-werror --enable-secureplt --enable-multilib --with-multilib-list=m32,m64 --enable-libmudflap --disable-libssp --enable-libgomp --with-python-dir=/share/gcc-data/x86_64-pc-linux-gnu/5.0.0/python --enable-checking=release --disable-libgcj --enable-libstdcxx-time --enable-languages=c,c++,fortran --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu --enable-targets=all --with-bugurl=http://bugs.gentoo.org/ --disable-bootstrap && make -j$(nproc) && make install && rm * -rf

# build bintuils
RUN git clone git://sourceware.org/git/binutils-gdb.git
WORKDIR binutils-gdb
RUN ./configure --enable-gold --enable-plugins --without-included-gettext --with-zlib --build=x86_64-pc-linux-gnu --enable-secureplt --prefix=/usr --host=x86_64-pc-linux-gnu --target=x86_64-pc-linux-gnu --datadir=/usr/share/binutils-data/x86_64-pc-linux-gnu/2.24 --infodir=/usr/share/binutils-data/x86_64-pc-linux-gnu/2.24/info --mandir=/usr/share/binutils-data/x86_64-pc-linux-gnu/2.24/man --bindir=/usr/x86_64-pc-linux-gnu/binutils-bin/2.24 --libdir=/usr/lib64/binutils/x86_64-pc-linux-gnu/2.24 --libexecdir=/usr/lib64/binutils/x86_64-pc-linux-gnu/2.24 --includedir=/usr/lib64/binutils/x86_64-pc-linux-gnu/2.24/include --enable-obsolete --enable-shared --enable-threads --enable-install-libiberty --disable-werror --with-bugurl=http://bugs.gentoo.org/ --with-pkgversion=Gentoo 2.24 p1.4 --disable-static --disable-gdb --disable-libdecnumber --disable-readline --disable-sim --without-stage1-ldflags --enable-lto && make -j$(nproc) && make install

# link LTO plugins
WORKDIR /abuild/
RUN touch test
RUN git clone https://github.com/marxin/gentoo-docker.git
RUN cp gentoo-docker/configuration/x86_64-pc-linux-gnu-5.0.0 /etc/env.d/gcc/
RUN mkdir -p /etc/portage/env && cp gentoo-docker/configuration/no-lto.conf /etc/portage/env
RUN cp gentoo-docker/configuration/package.env /etc/portage/
RUN gcc-config 2 && env-update && . /etc/profile
RUN mkdir -p /usr/x86_64-pc-linux-gnu/bin/../2.24/../lib/bfd-plugins && ln -s /usr/libexec/gcc/x86_64-pc-linux-gnu/5.0.0/liblto_plugin.so /usr/x86_64-pc-linux-gnu/lib/bfd-plugins/

# setup make.conf
WORKDIR /abuild/
RUN cp gentoo-docker/configuration/make.conf /etc/portage

# emerge, yeah!
RUN emerge -C python-exec && emerge numpy
RUN emerge inkscape gimp
