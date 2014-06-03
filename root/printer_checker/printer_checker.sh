#!/bin/bash

EUCLIDES=$(snmpwalk -v 1 -c euclides 192.168.240.41 iso.3.6.1.2.1.43.18.1.1.8 | cut -d'"' -f2)
GALOIS=$(./detect.sh)
LISTA=cebola

echo $EUCLIDES > /root/files/tmp/euc1.err
echo $GALOIS > /root/files/tmp/gal1.err

EUC_NEW=$(diff -q --line-format=%L /root/files/tmp/euc.err /root/files/tmp/euc1.err)
GAL_NEW=$(diff -q --line-format=%L /root/files/tmp/gal.err /root/files/tmp/gal1.err)

if [[ "$EUCLIDES" == "Such" ]] || [[ -z "$EUCLIDES" ]]; then
    EUCLIDES="none"
    EUC_NEW=""
fi

if [[ "$GALOIS" == "" ]] || [[ -z "$GALOIS" ]]; then
    GALOIS="none"
    GAL_NEW=""
fi
TEXT=$(printf "Euclides: $EUCLIDES\n\r  Galois: $GALOIS\n")
echo "helo linux.ime.usp.br" > /root/files/tmp/mailprinter.txt
echo "mail from: $LISTA@linux.ime.usp.br" >> /root/files/tmp/mailprinter.txt
echo "rcpt to: $LISTA@linux.ime.usp.br" >> /root/files/tmp/mailprinter.txt
echo "data" >> /root/files/tmp/mailprinter.txt
echo "Content-Type: text/html; charset=UTF-8" >> /root/files/tmp/mailprinter.txt
echo "From: Megazord <megazord@linux.ime.usp.br>" >> /root/files/tmp/mailprinter.txt
echo "To: $LISTA@linux.ime.usp.br" >> /root/files/tmp/mailprinter.txt
echo "Subject: TESTE: Printer Report" >> /root/files/tmp/mailprinter.txt
echo "" >> /root/files/tmp/mailprinter.txt
printf "<html><b>Euclides:</b> $EUCLIDES<br/><b>Galois:</b> $GALOIS</html>" >> /root/files/tmp/mailprinter.txt
echo "" >> /root/files/tmp/mailprinter.txt
echo "." >> /root/files/tmp/mailprinter.txt
echo "" >> /root/files/tmp/mailprinter.txt

DF=$(diff -q /root/files/tmp/mailprinter.txt /root/files/tmp/mailprinter.txt.old)

if [[ ! (-z "$DF")]] && ([[ ! (-z "$EUC_NEW") ]] || [[ ! (-z "$GAL_NEW") ]]); then

    telnet mail 25 < /root/files/tmp/mailprinter.txt

    cp /root/files/tmp/euc1.err /root/files/tmp/euc.err
    cp /root/files/tmp/gal1.err /root/files/tmp/gal.err
    cp /root/files/tmp/mailprinter.txt /root/files/tmp/mailprinter.txt.old

fi

if [[ "$EUCLIDES" == "none" ]]; then
    rm /root/files/tmp/euc.err
    touch /root/files/tmp/euc.err
fi
    
if [[ "$GALOIS" == "none" ]]; then
    rm /root/files/tmp/gal.err
    touch /root/files/tmp/gal.err
fi
