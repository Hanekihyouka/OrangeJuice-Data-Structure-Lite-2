#!/bin/bash
if [ ! -d instance/  ]
then
  mkdir instance/
fi

if [ ! -d audio  ]
then
  mkdir audio/
fi

if [ ! -d unzip/  ]
then
  mkdir unzip/
fi

oggpattern="bgm*.pak"
wavepattern="voice*.pak"

## 读取白名单
whitelistIndex=0
for line in `cat whitelist.txt`
do
    if  [ -f common/data/$line ]; then
        whitelist[$whitelistIndex]=$line
    else
        echo -e "\033[33m" "can not find file : " $line "\033[0m"
        echo "can not find file : " $line  >> warning.log
    fi
    ((whitelistIndex++))
done


for pak in ${whitelist[@]}
do    
    #  <<=== i may remove this part later
    # ogg
    if [[ $pak == $oggpattern ]]; then
    
        echo -e "\033[32m" $pak " -> ogg" "\033[0m"
        if [ ! -d audio/$pak  ]; then
            mkdir audio/$pak
        fi
        rm -rf audio/$pak/*
        ./mediaextract -f audio -o audio/$pak -a "{index}.{ext}" common/data/$pak
    
    # wave
    elif [[ $pak == $wavepattern || $pak == "se.pak" ]]; then

        echo -e "\033[32m" $pak " -> wave" "\033[0m"
        if [ ! -d audio/$pak  ]; then
            mkdir audio/$pak
        fi
        rm -rf audio/$pak/*
        java -jar OrangeJuice-WaveExtractor.jar common/data/$pak audio/$pak
        
    #  ===>> since audio files are zipped in audio.pak and all format in .oga   
    # zip
    elif [ $(xxd -l 4 -ps common/data/$pak) == "504b0304" ]; then

        echo -e "\033[32m" $pak " -> unzip" "\033[0m"
        if [ ! -d unzip/$pak  ]; then
            mkdir unzip/$pak
        fi
        rm -rf unzip/$pak/*
        rm -rf instance/$pak/*
        unzip -o common/data/$pak -d unzip/$pak
        echo -e "\033[32m" "  Convering image to png." "\033[0m"
        . ./img2png.sh
        
    else
        echo -e "\033[31m" "unknown magic : " $pak "\033[0m"
        echo "unknown magic : " $pak  >> warning.log
    fi
done
