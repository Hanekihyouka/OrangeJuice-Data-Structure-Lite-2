echo -e "\033[32m" "Start generating structure." "\033[0m"
if [ ! -d structure/  ]
then
  mkdir structure/
fi

for file in unzip/*
do
    if test -d $file
    then
        echo -e "\033[32m" $file " -> tree" "\033[0m"
        ./tree -Js --md5 $file > structure/$(basename $file .pak).json
    fi
done
