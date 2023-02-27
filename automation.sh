sudo apt update -y
ps cax | grep httpd
if [ $? -eq 0 ]; then
 echo "Apache is running."
else
 sudo apt install apache2
fi
service apache2 status
myname="koushik"
timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/access.log /var/log/apache2/error.log
s3_bucket="upgrad-koushik"
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

