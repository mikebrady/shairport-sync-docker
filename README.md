This is a very volatile repository right now. Please do not rely on it.

Shairport Sync is an Apple AirPlay audio player – it plays audio streamed from iTunes, iOS, Apple TV and macOS devices and AirPlay sources such as Quicktime Player and [ForkedDaapd](http://ejurgensen.github.io/forked-daapd/), among others. Multi-room audio is possible for players that support it, such as iTunes and the macOS Music app.

*Default settings:* The AirPlay service will have the host's `hostname`, audio output will be through the `alsa` sound system to the `default` output device and any hardware mixer the output device may have will not be used. The container will run in the background (`-d`) when the host starts up (`--restart unless-stopped`).

```
$ docker run -d --restart unless-stopped --net host --device /dev/snd \
    mikebrady/shairport-sync
```
*Extra settings:* Any settings you add to the end of the command line are passed to Shairport Sync. For example, to call the service `Lounge`, to output to alsa device `hw:1` and use the device's built-in hardware mixer control called `PCM` for volume control:
```
$ docker run -d --restart unless-stopped --net host --device /dev/snd \
    mikebrady/shairport-sync -a Lounge -- -d hw:1 -c PCM
```

*Debugging Session:* Here, the container is run interactively (`-it`) and will be deleted (`--rm`) upon exit. It is based on the `development` image. Shairport Sync is run with log verbosity of 1 (`-vu`) and statistics enabled (`--statistics`) :
```
$ docker run -it --rm --net host --device /dev/snd \
    mikebrady/shairport-sync:development -vu --statistics -a Lounge -- -d hw:1 -c PCM
```
Lots more information available at [https://github.com/mikebrady/shairport-sync](https://github.com/mikebrady/shairport-sync).

