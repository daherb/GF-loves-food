GF loves food
=============
Simple twitter bot that tweets about very italian food and ather stuff in various languages (powered by www.grammaticalframework.org)

Building
--------
Requires following haskell packages from hackage:
* gf
* aeson
* HTTP
* http-streams
* http-client-tls
* http-types
* authenticate-oauth

Also use the parameters -XRecordWildCards -XDeriveGeneric
Usage
-----
Create a config.json file with the content

```
    {
      "apiKey": "your consumer key",
      "apiSecret": "your consumer secret",
      "userKey": "your access token",
      "userSecret": "your access token secret"
    }
```

and place it together with a compiled grammatical framework grammar
called Foods.pgf in the same directory

Sources
-------
The twitter code is from http://kovach.me/posts/2014-08-09-twitter.html

Copyright (c) 2015 Herbert Lange
