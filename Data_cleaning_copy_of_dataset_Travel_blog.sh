#Command line (Bash) getting the data:
wget IPIPIPIPIPIPI/testtask/dilans_data.csv

#Command Line (Bash) creating 3 data sets from the main: first readers, returning readers, subscribers, buyers
cat dilans_data.csv | grep ’subscribe’ > /home/ownserver/dilans_subs.csv
cat dilans_data.csv | grep ’buy’ > /home/ownserver/dilans_buy.csv
cat dilans_data.csv | grep ’read’ > /home/ownserver/dilans_read.csv

#Separating first readers and returning readers from all readers file:
grep -E 'Reddit|AdWords|SEO' dilans_read.csv > dilans_first_read.csv
grep -E -v 'Reddit|AdWords|SEO' dilans_read.csv > dilans_more_reads.csv

#Creating Date and Time variables from Timestamp:
cat dilans_buy.csv | sed 's/ /;/' > dilans_buy_date.csv
cat dilans_subs.csv | sed 's/ /;/' > dilans_subs_date.csv
cat dilans_first_read.csv | sed 's/ /;/' > dilans_first_read_date.csv
cat dilans_more_reads.csv | sed 's/ /;/' > dilans_more_reads_date.csv
cat dilans_reads.csv | sed 's/ /;/' > dilans_reads_date.csv

#copy of data into SQL tables
\COPY dilans_firstreader FROM '/home/ownserver/dilans_first_read_date.csv' DELIMITER ';';
\COPY dilans_rereader FROM '/home/ownserver/dilans_more_reads_date.csv' DELIMITER ';';
\COPY dilans_subs FROM '/home/ownserver/dilans_subs_date.csv' DELIMITER ';';
\COPY dilans_purchase FROM '/home/ownserver/dilans_buy_date.csv' DELIMITER ';';

