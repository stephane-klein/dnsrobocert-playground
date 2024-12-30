# dnsrobocert playground

In my playground, I start by installing PowerDNS on a Scaleway instance.

Then I install dnsrobocert to generate Let's encrypt certificates with a DNS challange.

## Prerequisites

All workspaces require [Mise](https://mise.jdx.dev/).  

*Mise* is a “tooling version management” system that allows you to install most of the tools needed for a development environment.
It enables you to “pin” the precise versions of these tools.

### On OSX: install Mise with Brew

Brew is a popular package manager on *macOS*.
However, it does not come pre-installed: follow the instructions from the Brew [Website](https://brew.sh/index_fr):

```sh
$ brew install git mise
```

### On Fedora: install Mise with dnf

Install with *dnf* ([see official Mise instructions](https://mise.jdx.dev/installing-mise.html#dnf))

```sh
$ dnf install -y dnf-plugins-core
$ dnf config-manager --add-repo https://mise.jdx.dev/rpm/mise.repo
$ dnf install -y mise
```

### Configure Mise

Next, activate *mise* ([you can see official documentation](https://mise.jdx.dev/getting-started.html))

If you use **Bash** shell execute:

```sh
$ $ echo 'eval "$(mise activate bash)"' >> ~/.bashrc
$ source ~/.bash_profile
```

If you use **Zsh** shell execute:

```sh
$ echo 'eval "$(mise activate zsh)"' >> "${ZDOTDIR-$HOME}/.zshrc"
$ source ~/.zshrc
```

## Getting started

```sh
$ mise trust
$ mise install -y
$ terraform init
$ terraform apply
$ source .envrc.sh # to fetch SERVER1_IP
$ ./scritps/install_basic_server_configuration.sh
$ ./scripts/apply_dns_records.sh
```

Now, I add the following DNS records on the DNS server that manages the `stephane-klein.info` domain:

```
playground.stephane-klein.info.   1    IN   A   ${SERVER_IP}
playground.stephane-klein.info.   1    IN   NS  playground.stephane-klein.info.
```

This allows delegating the *.playground.stephane-klein.info subdomains to the PowerDNS server installed on ${SERVER_IP}.

Now I check that the DNS server is responding correctly:

```
$ dig test1.playground.stephane-klein.info +short
192.168.0.11
```

Deploy [dnsrobocert](https://dnsrobocert.readthedocs.io/):

```sh
$ ./scritps/deploy_dnsrobocert.sh
```

Next, see Let's Encrypt certificates:

```
$ ./scripts/enter_in_server1.sh
ubuntu@server1:~$ sudo cat /etc/letsencrypt/live/README
This directory contains your keys and certificates.

`[cert name]/privkey.pem`  : the private key for your certificate.
`[cert name]/fullchain.pem`: the certificate file used in most server software.
`[cert name]/chain.pem`    : used for OCSP stapling in Nginx >=1.3.7.
`[cert name]/cert.pem`     : will break many server configurations, and should not be used
                 without reading further documentation (see link below).

WARNING: DO NOT MOVE OR RENAME THESE FILES!
         Certbot expects these files to remain in this location in order
         to function properly!

We recommend not moving these files. For more information, see the Certbot
User Guide at https://certbot.eff.org/docs/using.html#where-are-my-certificates.
ubuntu@server1:~$ sudo ls /etc/letsencrypt/live/playground.stephane-klein.info/
README  cert.pem  chain.pem  fullchain.pem  privkey.pem
```

## Teardown

```
$ terraform destroy
```
