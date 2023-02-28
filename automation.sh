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
if [ ! -f /var/www/html/inventory.html ]; then
  touch /var/www/html/inventory.html
fi

echo "<html><head><title>Archived Logs Inventory</title></head><body>" > /var/www/html/inventory.html
echo "<h1>Archived Logs Inventory</h1>" >> /var/www/html/inventory.html
echo "<table>" >> /var/www/html/inventory.html
echo "<tr><th>Log Type</th><th>Date Created</th><th>Type</th><th>Size</th></tr>" >> /var/www/html/inventory.html

for file in /var/log/apache2/*log; do
  file_name=$(basename "$file")
  file_size=$(du -h "$file" | cut -f1)
  creation_date=$(date -r "$file" +"%Y-%m-%d %H:%M:%S")
  echo "<tr><td>$file_name</td><td>$creation_date</td><td>tar</td><td>$file_size</td></tr>" >> /var/www/html/inventory.html
done
echo "</table></body></html>" >> /var/www/html/inventory.html
chown www-data:www-data /var/www/html/inventory.html

CRON_SCHEDULE="0 0 * * *"

COMMAND="/home/ubuntu/GitRepos/Automation_Project/automation.sh"

CRON_FILE="automation"
echo "$CRON_SCHEDULE root $COMMAND" > "/etc/cron.d/$CRON_FILE"
chmod 644 "/etc/cron.d/$CRON_FILE"
