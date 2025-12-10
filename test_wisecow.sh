#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response_test

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
	read line
	echo $line
}

# Mocking fortune and cowsay
mock_fortune() {
    echo "This is a mocked fortune cookie for testing."
}

mock_cowsay() {
    echo " ________________________________________"
    echo "/ $1 /"
    echo " ----------------------------------------"
    echo "        \   ^__^"
    echo "         \  (oo)\_______"
    echo "            (__)\       )\/\\"
    echo "                ||----w |"
    echo "                ||     ||"
}

handleRequest() {
    # 1) Process the request
	get_api
	mod=$(mock_fortune)

cat <<EOF > $RSPFILE
HTTP/1.1 200


<pre>$(mock_cowsay "$mod")</pre>
EOF
}

echo "Wisecow (Test Mode) serving on port=$SRVPORT..."

while [ 1 ]; do
	cat $RSPFILE | nc -l $SRVPORT | handleRequest
	sleep 0.01
done
