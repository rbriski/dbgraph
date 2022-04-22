sleep 10 

apt-get dist-upgrade -y
apt-get update -y

sleep 10 
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
add-apt-repository "deb https://debian.neo4j.com stable 4.1"
apt install -y neo4j

systemctl enable neo4j.service