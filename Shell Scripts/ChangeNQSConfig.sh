!#/bin/bash
for ((i=1;i<=20;i++));
do
cd OracleBIServerComponent/coreapplication_obis${i}
sed -i "s/ENABLE = YES;  # This/ENABLE = NO;  # This/" NQSConfig.INI
#sed -i "s/ENABLE = NO;  # This/ENABLE = YES;  # This/" NQSConfig.INI
echo $i
grep -B2 -m1 "ENABLE = " NQSConfig.INI
cd ../../
done
exit