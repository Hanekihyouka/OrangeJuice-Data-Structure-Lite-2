#!/bin/bash
# XOR key in hex
key="6138596235244970566F62522C31587068216B28232142396824565B6F5B722D4927782E33375125453B6C74327747676B29684E465F705F216D463F447335342E2A38457262434B2C3330"
echo -e "\033[32m" "  Convering image to png." "\033[0m"

for datfile in $(find unzip/$pak -name "*.dat" )
do
    if test -f $datfile
    then
        datpath=$(dirname $datfile)
        outpath=${datpath/unzip/instance}
        datbasename=$(basename $datfile ".dat")
        if [ ! -d $outpath ]
        then
            mkdir -p $outpath
            echo "+" $outpath
        fi
        echo -e "\033[32m" $datfile ":" "\033[0m"
        
        # get file type
        dathead=$(xxd -l 4 -ps $datfile)
        if [ $dathead == "44445320" ] # dds
        then
            echo -e "\033[32m" "  png <- dds" "\033[0m"
            convert $datfile $outpath/$datbasename".png"
        elif [ $dathead == "257c0a42" ] # xor-dds
        then
            echo -e "\033[32m" "  png <- dds <- dds(xor)" "\033[0m"
            xortool-xor -h $key -f $datfile > $outpath/$datbasename".dds"
            convert $outpath/$datbasename".dds" $outpath/$datbasename".png"
            rm $outpath/$datbasename".dds"
        elif [ $dathead == "e8681725" ] # xor-png
        then
            echo -e "\033[32m" "  png <- png(xor)" "\033[0m"
            xortool-xor -h $key -f $datfile > $outpath/$datbasename".png"
        elif [ $dathead == "89504e47" ] # png
        then
            echo -e "\033[32m" "  png <- png" "\033[0m"
            ln $datfile $outpath/$datbasename".png"
        else
            echo -e "\033[31m" "unknown magic $dathead" "\033[0m"
        fi
        
    fi
done


