Experimenting with several OSes.

## installation procedure

- install debian / ubuntu
- run install.sh

- [ ] package compiled amd64 ffmpeg binaries into repo, download to each new reciever
- [ ] script to watch for NDI streams from specific source
- how to specify the NDI source to watch at?
    - specify file location on network?
    - local website with html form input?
    (complicated, but should work)


## compilation procedure

- download NDI SDK, if not already available (package in repo?)
- download ffmpeg source, if not already available (package in repo?)
- checkout ffmpeg commit from prior to removal of NDI
- download x264 source & compile
- move NDI files to subdirectory of ffmpeg source
- compile ffmpeg & install

## watch for NDI streams

This part involves too many unknowns. Wait and talk with Carlos.

- ffmpeg can get a list of available streams
- parse with grep / regex / etc.
- play stream with ffmpeg
- HOW TO CLOSE STREAM? 
