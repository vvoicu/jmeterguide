
sudo apt-get install openjdk-8-jdk -y

cd /home/playground/Desktop

wget -c http://mirrors.ukfast.co.uk/sites/ftp.apache.org//jmeter/binaries/apache-jmeter-5.1.1.tgz

tar -xf apache-jmeter-5.1.1.tgz

sudo chown playground: -R apache-jmeter-5.1.1

sudo cat <<EOF > /home/playground/Desktop/jMeter.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=jMeter
Comment=
Exec=/home/playground/Desktop/apache-jmeter-5.1.1/bin/jmeter
Icon=/home/playground/Desktop/apache-jmeter-5.1.1/docs/images/jmeter.png
Path=
Terminal=false
StartupNotify=false
EOF

sudo chown playground: /home/playground/Desktop/jMeter.desktop