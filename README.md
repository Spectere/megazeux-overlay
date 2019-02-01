# MegaZeux Gentoo Overlay

## What is MegaZeux?

MegaZeux is a text-based game creation system (GCS) that was originally released in 1994
and is still under active development to this day.

This is an overlay designed to make MegaZeux easier to install on Gentoo Linux systems.

For more information, including a library of available games, please visit
[DigitalMZX](https://www.digitalmzx.net).

## Installing MegaZeux

The first step is to add this overlay to your system. There are two ways of doing this:
by managing a repos.conf file yourself and using layman.

### repos.conf Method

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

### The layman Method

TODO: Write this. :(

In the meantime, this link should help you get up and running:
https://wiki.gentoo.org/wiki/Layman#Adding_custom_repositories
