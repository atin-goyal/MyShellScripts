Results_Dir="/scratch/perfuser/psrauto/Mails"
rm -v $Results_Dir/*.cfg
Results=`ls $Results_Dir`
touch $Results_Dir/batchloader_$today.cfg
for i in `echo $Results`
do
TestDate=`echo $i|cut -d'_' -f5|cut -d'.' -f1`
TestDate1=`date --date="$TestDate" +"%D %I:%M %p"`
TestName=`echo $i|cut -d'_' -f1`
TestName1=`echo $TestName|sed 's/\./ /'`
TestBuild=`echo $i|cut -d'_' -f2`
TestRelease=`echo $i|cut -d'_' -f3`
TestConfig=`echo $i|cut -d'_' -f4`
TestConfig1=`echo $TestConfig|sed 's/\./ /'`
cd /tmp
html=`unzip -o $Results_Dir/$i|grep -o -P '(?<=inflating: ).*(?=.html)'`
cd -
sh getComments.sh /tmp/$html.html
TestComments=`cat comments`
echo "$TestDate1,$TestName1,$TestBuild,$TestRelease,$TestConfig1,$TestComments"
cat >>$Results_Dir/batchloader_$today.cfg <<INPUT
IdcService=CHECKIN_UNIVERSAL
primaryFile=$i
dDocType=Document
dDocTitle=$i
dSecurityGroup=Public
dDocAuthor=weblogic
dStatus=RELEASED
dReleaseState=Y
xBuild_Label=$TestBuild
xComments=$TestComments
Action=insert
dInDate=$today1
xTest_Name=$TestName1
xRelease=$TestRelease
xTest_Date=$TestDate1
xHW_Config=$TestConfig1
<<EOD>>
INPUT
done
/scratch/perfuser/UCM/Installation/user_projects/domains/base_domain/ucm/cs/bin/BatchLoader -console -q -n$Results_Dir/batchloader_$today.cfg
exit