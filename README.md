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
* Groups results by episode, which are defined in configuration
* Automatically selects the most seeded torrent from the grouping
* Only download torrents NEWER than what you're already tracking
* Skips downloading torrents that you're already tracking
* Set a maximum limit of torrents to download, per title

## Configuration Files

The watchlist is stored in a YAML file located at ```~/.torrential_downpour/watchlist.yml```.  
It supports the following properties:

* term - Search term used to find torrents for this grouping.
* pattern - Regular expression used to match search results. Must contain an
```?<episode>``` named capture.  This is used to group multiple torrent
files of the same episode.
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
This file contains Transmission API connection details.  This is used to
add the new torrents to your BitTorrent client.

Example config.yml:
``` yaml
transmission_api_client:
    #username: username
    #password: password
    url: http://127.0.0.1:9091/transmission/rpc
```

This Transmission API obviously must be accessible when running this
program.

## Installation

To install this package as a gem, simply use:

``` sh
$ gem install torrential_downpour
```

You'll then need the 2 configuration files in their expected locations.  You
can either copy the examples provided in this gem, or simply create new ones
based on the examples described above.


## Usage

Torrential Downpour is intended to run in the background.  It uses 
[foreverb](https://github.com/DAddYE/foreverb) to demonize the process.
Use the `stop` and `start` commands to control the daemon.

``` sh
$ torrential_downpour start
$ torrential_downpour stop
```

#### Testing / Dry-Runs

You are able to skip actual downloading/tracking of torrents by providing
the `DRYRUN` environment variable.  When this environment variable is set,
this program essentially runs in read-only mode.  This is useful if you are 
testing the patten matching of the search results to ensure it's returning
only the results you're expecting.

``` sh
$ DRYRUN=1 torrential_downpour start
```

## TODO

- Package this as a gem
- Generalize the torrent search so it searches multiple sources (other than TPB)
- Improve scheduling options; perhaps each show on it's own schedule


## Credits

Written by Jason Hines, DevTwo
