About this library
==================

This is a cutdown fork of [the original *ae* library](https://github.com/CyberShadow/ae), you probably don't want to use this one.

License
=======

*Most* of this library is licensed under the [Mozilla Public License, v. 2.0](http://mozilla.org/MPL/2.0/).
Some modules may have a different license (e.g. public domain); check the comments at the top of each module for details.
You can generally expect the library to be GPL-compatible.

Using this library
==================

This fork of the library is designed to be built with [dub](http://code.dlang.org/about)

Overview
========

The library is split into the following packages:

 * `ae.demo` – This package contains a few demos for the library.
 * `ae.net` – All the networking code (HTTP, NNTP, IRC) lives here.
 * `ae.sys` – Utility code which primarily interfaces with other systems (including the operating system).
 * `ae.utils` – Utility code which primarily manipulates data.

Data
----

Many modules that handle raw data (from the network / disk) do so using the `Data` structure, defined in `ae.sys.data`.
See the module documentation for a description of the type; the quick version is that it is a type equivalent to `void[]`, with a few benefits.
Some modules use an array of `Data`, to minimize copying / reallocations when handling byte streams with unknown length.

Networking
----------

*ae* uses asynchronous event-based networking.
A `select`-based event loop dispatches events to connection objects, which then propagate them to higher-level code as necessary.
The library may eventually move to a generic event loop, allowing for asynchronous processing and multiple event loops for different subsystems.

Warning
=======

The library is in a constant state of flux, has no version numbers, and may never have a stable API.
At the moment, it is little more than common code I use in various projects, optimized/organized for however much my time/mood allowed at the moment.
The library may undergo significant changes, possibly even entire paradigm shifts, as I discover better/more efficient ways to use D.
