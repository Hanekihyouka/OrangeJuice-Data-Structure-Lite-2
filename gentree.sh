echo -e "\033[32m" "Start generating structure." "\033[0m"
if [ ! -d tree/  ]
then
  mkdir tree/
fi

for file in unzip/*
do
    if test -d $file
    then
        tree -Js $file > tree/$(basename $file .pak).json
    fi
done

for file in audio/*
do
    if test -d $file
    then
        tree -Js $file > tree/$(basename $file .pak).json
    fi
done
