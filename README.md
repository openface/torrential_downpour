## Torrential Downpour

Torrential Downpour is a simple integration tool which automates the
scheduling, tracking, and alerting of new torrents.  This is especially
useful for keeping up with specific television shows.  Torrential Downpour
will detect when a new episode of your show is available, select the best 
torrent file based on number of seeders, and begin tracking the torrent file.

It is primarily (at least for now) aimed at integrating ThePirateBay torrent
search, and Transmission BitTorrent client.  It works well with a headless
Transmission server or using Transmission client with remote access enabled.

It boasts the following features:

* Uses YAML files for configuration, no database or UI necessary 
* Runs as a background daemon, so you can fire and forget it
* Only download torrents NEWER than what you're already tracking
* Skips downloading torrents that you're already tracking
* Set a maximum limit of torrents to download, per title


## Prerequisites

TODO


## Configuration Files

Your watchlist is stored in a YAML file located at
```~/.torrential_downpour/watchlist.yml```.  It supports the following
properties:

* term - Search term used to find torrents for this grouping.
* pattern - Regular expression used to match search results. Must contain an
```?<episode>``` named capture.  This is used to group multiple torrents
of the same episode.
* only_newer - optional, default is true.
* fetch_limit - optional, default is 5.

Example watchlist.yml:
``` yaml
-
    term: Silicon Valley
    pattern: !ruby/regexp '/Silicon.Valley.(?<episode>S\d\dE\d\d)/'
    only_newer: true
-
    term: Homeland
    pattern: !ruby/regexp '/Homeland.(?<episode>S\d\dE\d\d)/'
    only_newer: true
    fetch_limit: 3
```

Other configuration is located at ```~/.torrential_downpour/config.yaml```.
This file contains Tranmission connection details.

Example config.yml:
``` yaml
transmission_api_client:
    #username: username
    #password: password
    url: http://127.0.0.1:9091/transmission/rpc
```


## Installation

To install this package as a gem, simply use:

``` sh
$ gem install torrential_downpour
$ torrential_downpour start
$ torrential_downpour stop
```

You'll then need to put the 2 configuration files in their expected
locations:

``` sh
$ cp /path/gems/torrential_downpour/watchlist.sample.yml ~/.torrential_downpour/watchlist.yml
$ cp /path/gems/torrential_downpour/config.sample.yml ~/.torrential_downpour/config.yml
```


## Usage

Torrential Downpour is intended to run in the background.  Use the `stop`
and `start` arguments to control the daemon.

``` sh
$ torrential_downpour start
[torrential_downpour] Pid not found, process seems doesn't exist!
[torrential_downpour] Process daemonized with pid 11693 with thread and Forever v.0.3.3
```


## TODO

- Package this as a gem; use post hook to install example config files
- Generalize the torrent search so it searches multiple sources (other than TPB)
- Improve scheduling options; perhaps each show on it's own schedule


## Credits

Written by Jason Hines, DevTwo
