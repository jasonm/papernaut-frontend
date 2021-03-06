Papernaut Frontend
==================

This is the web front end for <http://www.papernautapp.com>.

Overview
--------

The frontend works in two distinct phases: first, it helps you import papers
from a library.  Second, it shows you discussions for those papers.

You can import your papers from Zotero or Mendeley by giving Papernaut API
access to your libraries via OAuth.  Or, you can import papers from most
reference management software by uploading a `.bibtex` file.

Once your papers are loaded into the frontend, it issues requests to the
`papernaut-engine` HTTP API to request discussions that match papers in your
library.

The interface between the frontend and the engine are `Identifier` strings,
which take a prefix/value form:

    DOI:10.1038/nphys2376
    ISSN:1542-4065
    PMID:10659856
    URL:http://nar.oxfordjournals.org/content/40/D1/D742.full

Many papers will have multiple identifiers, and the frontend attempts to
clean, validate, canonicalize, and cross-reference your papers' identifiers as
best it can in an attempt to find the most matches.

Getting Started
---------------

1.  Set up and run the [papernaut-engine](http://github.com/jasonm/papernaut-engine).

2.  Register for Mendeley at <https://www.mendeley.com/join/>.  Register for a
    Mendeley OAuth key at <http://dev.mendeley.com>.

3.  Register for Zotero at <https://www.zotero.org/user/register/>.  Register
    for a Zotero OAuth key at <http://www.zotero.org/oauth/apps>.

4.  Install Redis, used by Sidekiq.

5.  Install gems:

        bundle install

6.  Create and migrate the databases.  PostgreSQL is used by default.

        rake db:create db:migrate db:test:prepare

7.  Create and edit the Foreman `.env` file to specify the web port and your API keys:

        PORT=3000
        MENDELEY_OAUTH_CONSUMER_KEY=api_key
        MENDELEY_OAUTH_CONSUMER_SECRET=api_secret
        ZOTERO_OAUTH_CONSUMER_KEY=api_key
        ZOTERO_OAUTH_CONSUMER_SECRET=api_secret

8.  For the automated tests to connect to Zotero via OAuth, provide your Zotero
    credentials in `.env`:

        ZOTERO_USERNAME=zotero.user@example.com
        ZOTERO_PASSWORD=i.love.my.library

    These are loaded in the test environment by the [`dotenv` gem](https://rubygems.org/gems/dotenv).

9.  If you chose a non-default URL for the papernaut-engine, also add a line to `.env`
    to specify its location.  The default is <http://localhost:3001>.

        PAPERNAUT_ENGINE_URL=http://localhost:3001

10.  Run the test suite to ensure things work on your system:

        rake

11. Run the application:

        foreman start

Deploying to production
-----------------------

See `DEPLOY.md` for information about deploying.

License
-------

See `LICENSE` file for the license applying to the code base.

The "Space Boy" graphic used in the homepage logo is by Russell Tate and is
licensed from iStockPhoto.com:

http://www.istockphoto.com/stock-illustration-1087779-space-boy.php

The graphic is licensed for a single-seat install and is in use at
http://www.papernautapp.com.  It is not licensed for multi-seat use, so any
other installations should purchase a separate license or use a different
image.

http://www.istockphoto.com/help/licenses
