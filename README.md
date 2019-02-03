# MegaZeux Gentoo Overlay

## What is MegaZeux?

MegaZeux is a text-based game creation system (GCS) that was originally released in 1994
and is still under active development to this day.

This is an overlay designed to make MegaZeux easier to install on Gentoo Linux systems.

For more information, including a library of available games, please visit
[DigitalMZX](https://www.digitalmzx.net).

## Installing MegaZeux

The first step is to add this overlay to your system. There are two ways of doing this:
by using layman or by creating a repos.conf file for the overlay yourself.

### The layman Method

This method requires you to touch fewer files by hand and will probably work best for most
users.

After installing [layman](https://wiki.gentoo.org/wiki/Layman), bring open your terminal of
choice and run the following as `root`:

`layman -o https://raw.githubusercontent.com/Spectere/megazeux-overlay/master/megazeux-layman.xml -f -a megazeux`

You should now be able to simply `emerge megazeux`! Be sure to run `layman -S` once in a
while to sync all of your layman repositories (or `layman -s megazeux` to only sync this
one).

### repos.conf Method

This method works well but requires a little bit of manual effort to get set up. If you
don't feel like messing around with your portage configuration files directly, give the
layman method a try first.

First, you'll need to create a directory to house this overlay's ebuild files. Personally,
I store this overlay in `/usr/local/portage/megazeux`.

Next, create a file in your `/etc/portage/repos.conf/` directory called `megazeux.conf`.
Copy and paste the following files into the new file:

````
[megazeux]
location = /usr/local/portage/megazeux
sync-type = git
sync-uri = https://github.com/Spectere/megazeux-overlay.git
priority = 10
````

**Note:** Be sure to change the `location` attribute if you are placing the overlay elsewhere.

The overlay is now set up to automatically sync when you run `emerge --sync`. Do so now and
it will retrieve the overlay and place it in your chosen directory. From here, you can simply
`emerge megazeux` and begin playing and creating.

## USE Flags

This ebuild currently supports the following USE flags:

* `mikmod` - *(global)* Uses `media-libs/libmikmod` to decode module music files.

* `sdl-legacy` - *(local)* Uses `media-libs/libsdl` instead of `media-libs/libsdl2`. SDL2
                 is highly recommended, but SDL1 works fine if you are unable to use SDL2
                 or would prefer not to.

* `tremor` - *(local)* Uses `media-libs/tremor` to decode Vorbis audio instead of
             `media-libs/libvorbis`. Tremor is better suited for older and embedded
             systems.
* `vorbis` - *(global)* Enables support for `media-libs/libvorbis`.

* `xmp` - *(local)* Uses libxmp (included in MegaZeux) to decode module music files.

This ebuild is designed to mimick the default canonical MegaZeux distribution as closely as
possible by default. This results in the following design choices:

* **SDL1 and SDL2 selection is done differently than in other Gentoo packages.** While
  MegaZeux has solid SDL1 support and continues to support it, most of the testing is done
  using SDL2 builds. Therefore, instead of defaulting to SDL1 and requiring a flag to
  use SDL2, MegaZeux uses SDL2 by default unless the `sdl-legacy` flag is set.

* **libxmp is the preferred module playback system.** MegaZeux only supports being built
  with a single module file decoder. Furthermore, MegaZeux's preferred module player is
  contained within its source tarball and is not in portage. This player, `libxmp`, is
  enabled by default and is used unless the `xmp` flag is explicitly disabled. This was
  done to allow users to keep the `mikmod` flag enabled globally while ensuring that the
  most well-supported decoder is enabled by default. If no supported module loaders are
  selected, module music playback will be disabled.

* **`tremor` overrides `vorbis`.** As with the module decoders, only a single Vorbis
  decoder can be compiled into MegaZeux at any given time. If both `vorbis` and `tremor`
  are specified, `libtremor` will be used. If `tremor` is set and `vorbis` is unset,
  `libtremor` will still be used. Finally, if neither of these USE flags are enabled,
  Vorbis playback will be disabled.
