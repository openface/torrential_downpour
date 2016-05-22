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

## Configuration

### Setup Your Watchlist

Edit ```~/.torwatch/watchlist.yml```

``` yaml
-
    term: Silicon Valley
    pattern: !ruby/regexp '/Silicon.Valley.(?<episode>S\d\dE\d\d)/'
    only_newer: true
```

Edit ```~/.torwatch/config.yaml```
``` yaml
transmission_api_client:
    #username: username
    #password: password
    url: http://127.0.0.1:9091/transmission/rpc
```


## Installation

``` sh
$ sudo gem install torrential_downpour
$ githubwatcher start
$ githubwatcher stop
```

## TODO

- Package this as a gem
- Generalize the torrent search so it searches multiple sources (other than TPB)
- Improve scheduling options; perhaps each show on it's own schedule

## Author

Written by Jason Hines, <jason@devtwo.com>
