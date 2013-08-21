Overview
========

This is a default [chef repository](https://github.com/opscode/chef-repo),
which contains the necessary recipes to run your own cloud services. The first
milestone is to get a secure mail server running.

Note that this is being developed with the intent of deploying it on Amazon EC2,
but it should be possible to apply this wherever you can run a Fedora 19.

The choice of using Fedora is very simple: it's the one I use as my daily
desktop, and it provides the most recent software for pretty much everything.
If you intend to run Ubuntu, take a look at my [other repository](https://raw.github.com/jpkrohling/chef-repo-kroehling),
where I experimented with Ubuntu 12.04 for the mail server, but I didn't
get satisfied with some things (related to security, mostly).

I'll provide more detailed instructions on how to use this, but mainly,
you'll need a chef server somewhere (Opscode's Hosted Chef is a good start),
a server somewhere (EC2 free tier is also a good start), a SSL certificate
(StartSSL is a good start), and, of course, a domain name. Besides that,
you'll need some knowledge in DNS configuration, as well as chef.

The quality of these recipes is somewhat low when comparing with Opscode's
recipes, specially due to the lack of tests. I plan to add those in the future
but for now, I'll be satisfied when my ties with Google are cut.