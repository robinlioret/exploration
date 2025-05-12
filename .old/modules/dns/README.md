# Module DNS

Ease the usage of local domain names for the tests. It deploys a simple CoreDNS instance that resolve the given domain to 127.0.0.1. By default, the domain is `sandbox.local`.

It is required to edit your `/etc/resolv.conf` file and add `nameserver 127.0.0.1` on top of the other ones.

## Usage

Deploy the example for `modules/dns/examples/simple`. Then open a browser and go to http://nginx.sandbox.local. The url will be resolve automatically to your localhost. Therefore, any ingress or gateway set up for the domain will be resolve as well.
