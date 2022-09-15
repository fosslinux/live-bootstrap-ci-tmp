# SPDX-FileCopyrightText: 2022 Dor Askayo <dor.askayo@gmail.com>
# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
# SPDX-FileCopyrightText: 2022 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

urls="http://mirrors.kernel.org/gnu/libtool/libtool-2.4.7.tar.xz
 http://git.savannah.gnu.org/cgit/gnulib.git/snapshot/gnulib-a521820.tar.gz"

src_prepare() {
    default

    rm -f build-aux/ltmain.sh
    rm -f doc/*.info
    rm -f bootstrap

    ../../import-gnulib.sh

    LIBTOOLIZE=true AUTOPOINT=true ../../bootstrap-helper.sh

    LIBTOOLIZE=true AUTOPOINT=true AUTOMAKE=automake-1.11 ACLOCAL=aclocal-1.11 AUTOCONF=autoconf-2.64 AUTOHEADER=autoheader-2.64 autoreconf-2.64 -fi
    LIBTOOLIZE=true AUTOPOINT=true AUTOMAKE=automake-1.11 ACLOCAL=aclocal-1.11 AUTOCONF=autoconf-2.64 AUTOHEADER=autoheader-2.64 autoreconf-2.64 -fi libltdl
}

src_configure() {
    ./configure \
        --prefix="${PREFIX}" \
        --libdir="${PREFIX}/lib/musl" \
        --disable-shared \
        --host=i386-unknown-linux \
        --target=i386-unknown-linux \
        --build=i386-unknown-linux \
        ac_path_EGREP="egrep" \
        ac_path_FGREP="fgrep" \
        ac_path_GREP="grep" \
        ac_path_SED="sed"
}

src_compile() {
    make AUTOM4TE=autom4te-2.64 MAKEINFO=true
}

src_install() {
    make install MAKEINFO=true DESTDIR="${DESTDIR}"

    sed -i -e "s/{EGREP=.*/{EGREP='egrep'}/" \
        -e "s/{FGREP=.*/{FREGP='fgrep'}/" \
        -e "s/{GREP=.*/{GREP='grep'}/" \
        -e "s/{SED=.*/{SED='sed'}/" \
        "${DESTDIR}/usr/bin/libtool"
}