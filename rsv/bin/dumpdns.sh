#! /bin/bash

domain=$(dnsdomainname)
[[ $domain ]] || domain=none

if [[ $domain = 'rsvm.se' ]]; then
    # Only dump rsvm.se when in rsvm.se
    host -al rsvm.se > $HOME/db/all-hosts
    exit 0
fi

for d in acc.rsv.se. bmp.rsv.se. db.rsv.se. dmz.rsv.se. infra.rsv.se. ipa.rsv.se. kap.rsv.se. \
         labb.rsv.se. lb.rsv.se. meet.rsv.se. ocp.rsv.se. labb.ocp.rsv.se test.ocp.rsv.se. \
         prod.ocp.rsv.se ppx.rsv.se. pro.rsv.se. prov.rsv.se. rel1.rsv.se. rex.rsv.se. rsv.rsv.se. \
         sys.rsv.se. test-dmz.rsv.se. test.rsv.se. utv.rsv.se. rsv.se. \
         skv.se test.skv.se. skvinfra.se. \
         val.se test.val.se. pro.val.se. ; do
    host -al $d
done > $HOME/db/all-hosts

# ibx.rsv.se don't allow zonetransfer for rsvm.se
for d in rsvm.se; do
    host -al $d v00001.rsvm.se
done >> $HOME/db/all-hosts
    
