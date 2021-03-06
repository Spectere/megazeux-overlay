# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="A text-based game creation system."
HOMEPAGE="https://www.digitalmzx.net/"
SRC_URI="https://vault.digitalmzx.net/download.php?latest=src&ver=${PV} -> ${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="mikmod modplug -sdl-legacy -tremor vorbis +xmp"
IUSE="mikmod -sdl-legacy -tremor vorbis +xmp"

DEPEND="!sdl-legacy? ( media-libs/libsdl2 )
		sdl-legacy? ( media-libs/libsdl )
		!tremor? ( vorbis? ( media-libs/libvorbis ) )
		tremor? ( media-libs/tremor )
		!xmp? ( mikmod? ( media-libs/libmikmod ) )"
		#!xmp? ( mikmod? ( !modplug? ( media-libs/libmikmod ) ) )"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/mzx$(ver_rs 1-2 '')"

src_configure() {
	local mod_conf
	local ogg_conf

	# Modplug builds are broken in v2.91i so let's just save this for later. :)
	#if use xmp && ( use modplug || use mikmod ) ; then
	#	ewarn "Both xmp and either modplug or mikmod USE flags were defined. Using libxmp."
	#elif ! use xmp && ( use modplug && use mikmod ) ; then
	#	eerror "This package does not support multiple module players. If the xmp USE flag"
	#	eerror "is disabled, you must choose whether you want to use modplug or mikmod."
	#	eerror ""
	#	eerror "To do this, add one of the following lines to either /etc/portage/package.use"
	#	eerror "or /etc/portage/package.use/megazeux:"
	#	eerror ""
	#	eerror "    To use modplug: games-engine/megazeux modplug -mikmod"
	#	eerror "    To use mikmod:  games-engine/megazeux mikmod -modplug"
	#	eerror ""
	#	die
	#elif ! use xmp && use modplug ; then
	#	mod_conf="--enable-modplug"
	#elif ! use xmp && use mikmod ; then
	#	mod_conf="--enable-mikmod"
	#elif ! use xmp && ! use modplug && ! use mikmod ; then
	#	mod_conf="--disable-xmp"
	#fi

	if use xmp && use mikmod ; then
		ewarn "Both the xmp and mikmod USE flags are defined. Using libxmp."
	elif ! use xmp && use mikmod ; then
		mod_conf="--enable-mikmod"
	elif ! use xmp && ! use mikmod ; then
		mod_conf="--disable-xmp"
	fi

	if ! use vorbis && ! use tremor ; then
		ogg_conf="--disable-vorbis"
	elif use tremor ; then
		ewarn "Both vorbis and tremor USE flags were defined. Using media-libs/tremor."
		ogg_conf="--enable-tremor"
	fi

	./config.sh --platform unix --prefix /usr --sysconfdir /etc --gamesdir /usr/bin $(use_enable !sdl-legacy libsdl2) ${ogg_conf} ${mod_conf}
}

src_install() {
	emake DESTDIR="${D}" install

	# Rename the documents directory to follow FHS/Gentoo conventions.
	mv "${D}"/usr/share/doc/megazeux "${D}"/usr/share/doc/"${PF}"

	# Un-gzip the documentation so that portage can handle it.
	for f in "${D}"/usr/share/doc/"${PF}"/*.gz; do
		gunzip "${f}"
	done

	# Remove the deprecated "Application" category from the desktop files.
	sed -i "s/Categories=Application;Game;/Categories=Game;/" "${D}"/usr/share/applications/*.desktop
}
