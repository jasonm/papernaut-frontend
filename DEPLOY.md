Deploying to production
=======================

Heroku is recommended.

Set the following required environment variables:

```
SECRET_TOKEN:                   (redacted)...
MENDELEY_OAUTH_CONSUMER_KEY:    (redacted)
MENDELEY_OAUTH_CONSUMER_SECRET: (redacted)
ZOTERO_OAUTH_CONSUMER_KEY:      (redacted)...
ZOTERO_OAUTH_CONSUMER_SECRET:   (redacted)...
REDISTOGO_URL:                  redis://(redacted)...
PAPERNAUT_ENGINE_URL:           http://papernaut-engine.herokuapp.com
```

Optionally set a canonical host to 301 non-canonical hosts to this
(used to redirect papernautapp.com to www.papernautapp.com):

```
CANONICAL_HOST:                 www.papernautapp.com
```

Optionally use CloudFront as a CDN as described on
<http://blog.arvidandersson.se/2011/10/03/how-to-do-the-asset-serving-dance-on-heroku-cedar-with-rails-3-1>:

```
ASSET_HOST:                     //whatever.cloudfront.net
```
