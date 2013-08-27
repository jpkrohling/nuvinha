# Overview

This is a default [chef repository](https://github.com/opscode/chef-repo),
which contains the necessary recipes to run your own cloud services. 

## Features

- SELinux activated
- Hostname setting
- MariaDB installation and configuration
- Firewall with iptables
- Apache with PHP and SSL
- Automatic SSL certificates and CSR creation
- Postfix and Dovecot integrated with MariaDB
- OpenDKIM
- Roundcube
- Auto-provisioning of EBS volume for mail storage

### Optional features

- ownCloud with automatic provision of EBS volume for storage
- New Relic monitoring

## Roadmap

- EBS provisioning for MariaDB data
- Detecting if the deployment is being made on EC2 and skip the EBS provisioning if it's not EC2
- OpenLDAP for account information storage and integration with Postfix, Dovecot and ownCloud
- Jabber server
- OpenID server (looking for recommendations)

## Usage

### Before you start

Before you start, you need to be aware of some things. 

#### The quality of the cookbooks is not really high!

Even though I took care of doing what I thought was the best practice, I'm by no means an Opscode Chef expert. 
This means that there are no tests as the Opscode's official recipes have. My main idea was not to provide you 
with a service, but to get my mail server working. If this is a problem for you, I accept pull requests adding tests.

#### Works only on Fedora

I have not tested on CentOS or Red Hat, or even in older versions of Fedora. It was tested with Fedora 19 only,
so, I know it works there. I know that it should *not* work on Ubuntu or Debian-based distributions, specially
because the OpenSSL and Apache cookbooks calls `yum` directly. If you need to run this on CentOS/Red Hat, you can
try to use this as a starting point, but I guess there will be a lot of work to get it working. 

#### You need to do some stuff before you start!

Specially:

- Get an account with a Certificate Authority for your SSL certificates. Most of the CAs are able to sign CSR's
(certificate signing requests), so, you don't need to get a certificate *before* you start, but it's not a problem
if you already have one. [StartSSL](https://www.startssl.com) is a good starting point. 
- Get an Opscode Chef server. I shouldn't matter if it's a Hosted Chef or a Private Chef. For what it's worth: I
tested with Hosted Chef (ie: the version that Opscode hosts for free for up to 5 nodes).
- Get an Amazon EC2 account. While I originally intended to make this compatible with any provider that would allow
you to install a Fedora 19, I decided to break this promise when I created the auto-provisioning of EBS storage for 
the mail server and for ownCloud. So, if you need/want to have your mail server outside of EC2, you just need to
remove the EBS support from the two places where I've added it: on the `mailserver` cookbook, `storage` recipe and
on the `owncloud` cookbook, `storage` recipe. 
- Get a New Relic account. This is actually optional, and you can safely remove the `newrelic` cookbook from the 
role files (`email` and `drive`). 
- Patience. If you want to have your own mail server, face this as a "DIY weekend project". While I believe it should
be possible to complete the entire setup in a couple of hours, you might want to review some stuff first, and do it
one time for "testing", and then one time for real. 
- If you want [Forward Secrecy](http://en.wikipedia.org/wiki/Perfect_forward_secrecy), you'll need to prepare and
compile your own openssl-dev and httpd packages. Don't worry, I've prepared a 
[quick how-to](https://coderwall.com/p/tmaytq) for this. 

## Tips

- If anything goes wrong, just log into the machine (`ssh fedora@ec2-......com`) and try to run the command again. 
The output given by the chef-client isn't always optimal. It should then fail with a better error message. If not,
try to look for hints on the log files, at `/var/log`. 
- Use `screen`. 
- Before you start debugging a problem, just run `sudo chef-client --once` again, to see if the problem persists. 

## Instructions

- When you registered at Opscode for Hosted Chef, you should have received two PEM files: a validator and
a client key. You should also have entered an "organization" name. Use them on the `.chef/knife.rb` configuration file.
Use the `.chef/knife.rb.sample` as a starting point. 
- On the same file, you'll see a reference to AWS credentials. Either export environment variables named after
the values on the file, or just replace the values there. If you replace it there, double-check your commits to make
sure you won't leak this data. 
- The next step is to add the Apache's and OpenSSL's packages to the `files/default` directory from the cookbooks. 
See the "Forward secrecy" item from the list of things you need to do before you start. In the end, you should have
these: 

```bash
$ ls -1 cookbooks/apache/files/default/ cookbooks/openssl/files/default/
cookbooks/apache/files/default/:
httpd-2.4.6-3.fc19.x86_64.rpm
httpd-tools-2.4.6-3.fc19.x86_64.rpm
mod_ssl-2.4.6-3.fc19.x86_64.rpm

cookbooks/openssl/files/default/:
openssl-1.0.1e-5.fc19.x86_64.rpm
openssl-devel-1.0.1e-5.fc19.x86_64.rpm
openssl-libs-1.0.1e-5.fc19.x86_64.rpm
```
- Next is to change the `email` role and comment out everything after the `base` recipe. This way, you have a quick boot
and we can add recipes one at a time. This is required if you are using a t1.micro instance, as the initial bootstrap
from chef can consume a lot of memory, causing a "Cannot allocate memory". 
- Now, upload all cookbooks and roles: 

```bash
$ knife cookbook upload -a
$ knife role from file roles/*rb
```
- And finally, bootstrap an instance: 

```bash
$ knife ec2 server create -I ami-f1031e85 -g ssh-bastion,default,web-server,mail-server -x fedora -f t1.micro -r "role[email]" -N mail
```

What this command does is:

* Creates a new EC2 server
* With a Fedora 19 x86_64 AMI (ami-f1031e85)
* Under the security groups "ssh-bastion,default,web-server,mail-server"
* Logging in as the `fedora` user
* On a t1.micro instance
* Applying the role `email` to it
* And naming it `mail`. This name will appear on EC2 console, on Opscode's Hosted Chef and will be used as the host 
part of the FQDN (ie: mail.yourdomain.tld). 

Once you get a machine booted, update everything: `$ sudo yum update -y`. Make sure you always have the latest software, specially to 
be better protected against known security vulnerabilities. Once you finish the updates, you might need to reboot via EC2 console,
as there will probably be a kernel update. 

- After the reboot, run the chef-client manually once, so that it sets up the hostname properly: `$ sudo chef-client --once`. 
- Uncomment one recipe from the role `email`, upload the role to the chef server with `knife role from file roles/email.rb` and 
run `sudo chef-client --once` .
- Repeat the same steps for each of the recipes. 
- Note that the recipe `roundcube` might fail when enabling a selinux boolean. Unfortunately, I wasn't able to see why chef fails, 
and why it always works manually. So, to avoid problems, run this command before the first execution of the `roundcube` cookbook
(ie: before you uncomment it from the role): `sudo /usr/sbin/setsebool -P httpd_can_network_connect on`.
- Once you finish all the recipes, you should have some certificates on `/etc/pki/tls/certs` and `/etc/pki/tls/private`, named 
mail.YOURDOMAIN.TLD. If you already have your certificate, just replace the contents of the certificate from `certs` with 
the contents from your existing file. Same for the file in `private`, replacing it with your key. If you don't have a certificate
already, you can find the CSR on the node's property on the chef web interface, under the property `csr_outbox`. Once you get the 
signed certificate, use the [`chef-ssl`](http://community.opscode.com/cookbooks/x509) utility to update your node. 
- Populate the database for the database users:

```sql
INSERT INTO `mailserver`.`virtual_domains`
  (`name`)
VALUES
  ('newdomain.com');

INSERT INTO `mailserver`.`virtual_users`
  (`domain_id`, `password` , `email`)
VALUES
  ('1', ENCRYPT('newpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))) , 'email3@newdomain.com');

INSERT INTO `mailserver`.`virtual_aliases`
  (`domain_id`, `source`, `destination`)
VALUES
  ('5', 'alias@newdomain.com', 'myemail@gmail.com');
```

- Populate the Roundcube database: `mysql -u root -p roundcube < /usr/share/doc/roundcubemail-0.9.2/SQL/mysql.initial.sql`
- Run the ownCloud setup at: https://mail.DOMAIN.TLD/owncloud . For the initial setup, you'll need this:
`GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' IDENTIFIED BY 'password';`. You can get MySQL's root password
on the node's properties on chef, under the property `mariadb/root_password`. You can get ownCloud's DB password on the 
property `owncloud/database/password`. 
- You should now be ready :-) Enjoy! 
