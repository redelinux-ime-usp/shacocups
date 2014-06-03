problems=$(snmpwalk -v 2c -c public 192.168.240.42 iso.3.6.1.2.1.43.18.1.1.7.1 | cut -f4 -d' ')

for code in $problems
do
    case $code in
        "8")
            #Error
            echo "Jam."
            ;;
        "1104")
            #Alert
            echo "Low toner."
            ;;
        "1101")
            #Error
            echo "Out of toner."
            ;;
        "808")
            #Error
            echo "Out of paper."
            ;;
        "1")
            #Error
            echo "Formato de papel incorreto."
            ;;
        "Such")
            ;;

         *)
            echo "Code: $code"
            ;;
    esac
done
