export LANG="en_US.UTF-8"
path='./txt'
files=$(ls $path)

listStr='姓名,性别,年龄,电话,地址' # 表头字段

for filename in $files
do
  #  echo $filename >> filename.txt
  txtPath=${path}"/"${filename}
  # echo $txtPath
  if [[ $txtPath =~ .txt$ ]]
  then
    # echo 'txt 转码utf-8'
    listStr=${listStr}"\n"
    iconv -f gbk -t utf8 $txtPath > $txtPath.utf8

    name="姓名"
    sex="性别"
    age="年龄"
    phone="电话"
    address="地址"

    exec < $txtPath.utf8
    while read line
    do
	    lineLength=${#line}
      if [[ $line =~ '姓名：' ]]
      then
        name=${line##*姓名：}
        # name=${line:3:3}
        # echo '名字吗'$name
      elif [[ $line =~ '性别：' ]]
      then
        sex=${line#*性别：}
      elif [[ $line =~ '年龄：' ]] && [[ $lineLength -lt 10 ]]
      then
        age=${line#*年龄：}
      elif [[ $line =~ '手机1：' ]]
      then
        phone=${line#*手机1：}
      elif [[ $line =~ '电话：' ]] && [[ $phone == '电话' ]]
      then
        phone=${line#*电话：}
      elif [[ $line =~ '住址：' ]]
      then
        address=${line#*住址：}
      fi
    done

    # echo 'name:'${name}
    # echo 'sex:'${sex}
    # echo 'age:'${age}
    # echo 'phone:'${phone}
    # echo 'address:'${address}
    csvRow=${name}","${sex}","${age}","${phone}","${address} # 拼接每个字段并用逗号分隔
    
    csvRow=$(echo $csvRow | sed -e 's/\r//g') # 删除字符串中的换行符
    echo $csvRow
    listStr=${listStr}${csvRow}
  fi
done
# echo $listCSV
echo $listStr > csv/list.csv

