# sync_external_device

Simple config-driven synchronization tool (bidirectional)

## Required: 
* unison
* systemd
* libnotify

## Installation
* modify the sync_external_device.service to fit your needs
    * set the appropriate mount unit
    * set the appropriate path to sync_external_device.sh
* install the sync_external_device.service as an user service (https://wiki.archlinux.org/index.php/Systemd/User)

## Device configuration
* Add a .foldersync file to the root of the external device
* Each section corresponds to a pair of mapped folders
    * Local: The folder on your machine
    * Remote: The folder on your device
  
## Current test state:
* FAT32 stick (unison is also configurated to use fat)
* One mapping. Multiple mappings SHOULD work but weren't tested yet
