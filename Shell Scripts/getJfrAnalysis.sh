echo "Enter number of seconds"
read seconds
echo -e "enter jfr mode: 1 or 2 \n 1 for parsing jfr alone \n 2 for parsing jfr along with sql query information "
read dbarg
if [ $# -eq 1 ] &&  [ $dbarg -eq 1 ] ||  [ $dbarg -eq 2 ]
then
for jfr_name in $(ls $1/*.jfr | grep -i 'jfr')
do
name=$(basename $jfr_name)
echo -e "parsing jfr name  $name  ";
echo -e "================================================================================================================"
ls  $jfr_name | awk '{print  "/net/adc4110092.us.oracle.com/scratch/fusionapps/jdeveloper/project/mywork/JFRAnalyzer/runAnalyzer.sh " $1 " '"$seconds"' '"$dbarg"'"}' | bash | grep -v  "Task finished!"
echo -e "finished parsing jfr $(basename $name) \n ";
done
else
echo -e "please enter proper inputs \n"
fi
