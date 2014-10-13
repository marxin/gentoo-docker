FROM plabedan/gentoo
MAINTAINER Martin Liška

RUN emerge zip unzip

WORKDIR /abuild/
RUN wget --no-check-certificate https://github.com/marxin/gcc/archive/docker.zip -O docker.zip
RUN unzip docker.zip
WORKDIR gcc-docker
RUN mkdir objdir 
WORKDIR objdir

RUN ../configure --prefix=/usr --bindir=/usr/x86_64-pc-linux-gnu/gcc-bin/5.0.0 --includedir=/usr/lib/gcc/x86_64-pc-linux-gnu/5.0.0/include --datadir=/usr/share/gcc-data/x86_64-pc-linux-gnu/5.0.0 --mandir=/usr/share/gcc-data/x86_64-pc-linux-gnu/5.0.0/man --infodir=/usr/share/gcc-data/x86_64-pc-linux-gnu/5.0.0/info --with-gxx-include-dir=/usr/lib/gcc/x86_64-pc-linux-gnu/5.0.0/include/g++-v4 --host=x86_64-pc-linux-gnu --build=x86_64-pc-linux-gnu --disable-altivec --disable-fixed-point --without-cloog --without-ppl --disable-lto --enable-nls --without-included-gettext --with-system-zlib --enable-obsolete --disable-werror --enable-secureplt --enable-multilib --with-multilib-list=m32,m64 --enable-libmudflap --disable-libssp --enable-libgomp --with-python-dir=/share/gcc-data/x86_64-pc-linux-gnu/5.0.0/python --enable-checking=release --disable-libgcj --enable-libstdcxx-time --enable-languages=c,c++,fortran --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu --enable-targets=all --with-bugurl=http://bugs.gentoo.org/ --disable-bootstrap && make -j$(nproc) && make install && rm * -rf
