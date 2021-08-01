#!/usr/bin/bash
BOTAPI=
URL=https://api.telegram.org/bot
ID2=$(cat id_file.txt)
while :
do
MESSAGE=$(curl -X POST "$URL$BOTAPI/GetUpdates?offset=-1" | tr "," "\n")
TEXT=$(curl -X POST "$URL$BOTAPI/GetUpdates?offset=-1" | tr "," "\n" | grep '"text":"' | sed 's/\<text\>//g' | tr -d ':"]}')
MESSAGEID=$(curl -X POST "$URL$BOTAPI/GetUpdates?offset=-1" | tr "," "\n" | grep '"message":{"message_id":' | tr -d '"message":{"message_id":')
echo ID=$MESSAGEID
echo ID2=$ID2
echo text=$TEXT
if [[ $ID2 == $MESSAGEID ]]
then
:
else
if [[ $MESSAGE == *"photo"* ]]
then
CHATID=$(curl -X POST "$URL$BOTAPI/GetUpdates?offset=-1" | tr "," "\n" | grep '"chat":{"id"' | tr -d 'chat:"{id')
echo $CHATID
echo id 1
FILEID=$(curl -X POST "$URL$BOTAPI/GetUpdates?offset=-1" | tr "," "\n" | grep "file_id" | tail -n 1 | tr -d '{:' | sed 's/\<file_id\>//g' | tr -d '"')
echo $FILEID
FILEPATH=$(curl -X POST "$URL$BOTAPI/getFile?file_id=$FILEID" | tr "," "\n" | grep "file_path" | sed 's/\<file_path\>//g' | tr -d '":}')
echo $FILEPATH
URLFILE=https://api.telegram.org/file/bot$BOTAPI/$FILEPATH
echo $URLFILE
wget -P $PWD/botfiles/ "$URLFILE"
source func.sh
proc
curl $URL$BOTAPI/sendPhoto -F chat_id=$CHATID -F photo=@$PWD/botfiles/img.jpg
ID2=$(echo $MESSAGEID)
echo $ID2 > id_file.txt
rm $PWD/botfiles/*.jpg
else
ID2=$(echo $MESSAGEID)
echo $ID2 > id_file.txt
fi
fi
done
exit 0