FWIW i get frequent dropouts. Only tested over wifi, so that is likely to be part of why.

as a client - follow alsa setup.

add `-h hostname` to `snapclient_opts` in `/etc/conf.d/snapcast-client`

service snapcast-client start
rc-update add snapcast-client


as a server - follow official docs with a similar pattern to above.
* https://github.com/badaix/snapcast/tree/master/doc
* https://mjaggard.github.io/snapcast/

