#install-pkg bc
#echo "insert text here" > new.txt
name="Sumon Biswas"
account='181002087'
bank='Operating System Bank LTD.'
branch='Mirpur, Dhaka.'
password=''
balance=0.00;
agents=()
coin=()
for word in $(<notes.txt)
do
  coin+=($word)
done
while IFS= read -r line; 
do
  agents+=($line)
done < agents.txt

for word in $(<balance.txt)
do
    balance=$word
done

for word in $(<password.txt)
do
    password=$word
done

Dynamic()
{
  w=$1
  w=$((w/100))
  ww=$(($w%${coin[0]}))
  if((ww!=0))
  then return
  fi
  coin_count=()
  res=()
  declare -A mat
  n=${#coin[@]}
  coins=0
  for((i=0;i<n;i++)){
    coin_count[$i]=0
  }
  Min()
  {
    if(($1<$2))
    then return $1
    else return $2
    fi
  }
  for((i=0;i<=$n;i++))
  do
    mat[$i,0]=0
    if(($i==0))
    then
      for((j=1;j<=$w;j++))
      do
        mat[$i,$j]=0
      done
    elif(($i==1))
    then
      for((j=1;j<=$w;j++))
      do
        temp=${coin[$((i-1))]}
        ind=$(($j-$temp))
        if(($ind<0))
        then
          mat[$i,$j]=1
        else mat[$i,$j]=$((1+${mat[$i,$ind]}))
        fi
      done
    else 
      for((j=1;j<=$w;j++))
      do
        temp=${coin[$((i-1))]}
        if(($temp>$j))
        then
          mat[$i,$j]=${mat[$((i-1)),$j]}
        else
          index=$(($j-$temp))
          n1=${mat[$((i-1)),$j]}
          n2=${mat[$i,$index]}
          n2=$((n2+1))
          Min $n1 $n2
          #echo $? w
          mat[$i,$j]=$?
          #echo ${mat[$i,$j]} mat
        fi
      done
    fi
  done

  j=$w;
  for((i=$n;${mat[$i,$j]}!=0;i--))
  do
    while((${mat[$i,$j]}!=${mat[$((i-1)),$j]}))
    do
      coins=$((coins+1))
      res+=(${coin[$((i-1))]})
      coin_count[$((i-1))]=$((${coin_count[$((i-1))]}+1))
      c=${coin[$((i-1))]}
      j=$((j-c))
    done
  done
  w=$((w*100))
  echo Minimum Notes Required: $coins to fill $w
  
  for((i=0;i<n;i++))
  do
    coin[$i]=$((${coin[$i]}*100))
    echo Note: ${coin[$i]} Count:${coin_count[$i]}
  done
  # for i in "${res[@]}"
  # do
  #   echo $i
  # done
  echo
}

Statement()
{
  while((1))
  do
    Check_Pass
    if(($?==1))
    then
      n=0
      while read line
      do
        n=$((n+1))
        echo $n. $line
      done <"trans.txt"
      echo Total Transactions Found $n
      echo Ending Balance: $balance
      break
    else 
      echo Wrong Password. Please Try Again.
      continue
    fi
  done
  echo
}

Check_Pass()
{
  read -p "Enter Password: " pass
  if [[ "$pass" == "$password" ]]
  then return 1
  else return 0
  fi
}

Number()
{
  x=$1
  if [[ $x =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; 
  then echo $x
  elif [[ $x =~ ^[+-]?[0-9]+$ ]]; 
  then echo "${x}.00"
  else 
    echo 0
  fi
}

Mobile_Withdraw()
{
 x=$1
 for i in "${agents[@]}"
 do
  if [[ "$x" == "$i" ]]
  then 
    Withdraw "Mobile Banking" $x
    return;
  fi
 done
 echo No Agents Found
}

Withdraw()
{
  method=$1
  while((1))
  do
    Check_Pass
    ok=$?
    if(($ok==1))
    then
      read -p "Enter Withdraw Amount (Amount must be a multiply of $((${coin[0]}*100))): " a
      a=$(  Number $a )
      if(($a%$((${coin[0]}*100))!=0))
      then
        echo Please Enter a multiply of $((${coin[0]}*100))
        continue
      elif(($a>250000))
      then
        echo Withdraw Amount Cannot Exceed 250000
        continue
      fi
      if(($a==0))
      then 
        echo Please Enter a Valid Amount
        continue
      else
        if (( $(echo "$balance > $a" |bc -l) )); then
        #then
          balance=`echo $balance-$a | bc`
          Dynamic $a
          echo "Withdrawn BDT $a by $method $2. Balance: $balance. Time: $(date)" >> trans.txt
          > balance.txt
          echo "$balance" >> balance.txt
          echo Withdraw Successfull. Current Balance is $balance;
          break
        else echo Insufficient Balance. Please try again.
        fi
      fi
    else 
      echo Wrong Password. Please Try Again.
      continue
    fi
  done
}

Account()
{
  while((1))
  do
    Check_Pass
    if(($?==1))
    then
      echo Account Name: $name
      echo Account Number: $account
      echo Balance: $balance BDT
      echo Bank Name: $bank
      echo Branch Name: $branch
      break
    else 
      echo Wrong Password. Please Try Again.
      continue
    fi
  done
}


echo Hi $name, Good Day
echo

switch=1;
echo 1. Echo 1
echo 2. Echo 2
echo 3. Check Balance
echo 4. Deposit Amount
echo 5. Withdraw
echo 6. Statement
echo 7. My Account
echo 8. Change Password
echo 9. Display Menu Again
echo 0. Exit

while((1))
do
  read -p "Enter a key: " switch
  case $switch in
    1)
      echo 1
      ;;
    2)
      echo 2
    ;;
    3)
      while((1))
      do
        Check_Pass
        ok=$?
        if(($ok==1))
        then 
          echo Your Current Balance is $balance;
          break
        else 
          echo Wrong Password
          continue
        fi
      done
    ;;
    4)
      read -p "Enter Deposit Amount: " a
      #Number a 
      #a=$?
      a=$(  Number $a )
      if(($a==0))
      then echo Please Enter a Valid Amount
      else
        balance=`echo $balance+$a | bc`
        echo "Deposit Amount: $a. Balance: $balance. Time: $(date)" >> trans.txt
        > balance.txt
        echo "$balance" >> balance.txt
        echo Your Current Balance is $balance;
      fi
    ;;
    5)
      echo 1. Mobile Banking
      echo 2. ATM 
      read -p "Enter Withdraw Method: " x
      if(($x==1))
      then
        read -p "Please enter the mobile number: " mobile;
        Mobile_Withdraw $mobile
      elif(($x==2))
      then 
        Withdraw "ATM"
      else echo Invalid Method Selection!
      fi
    ;;
    6)
      Statement
    ;;
    7)
      Account
    ;;

    8)
      while((1))
      do
        Check_Pass
        ok=$?
        if(($ok==1))
        then
          read -p "Enter New Password: " new 
          read -p "Confirm Password: " confirm
          if [[ "$new" == "$confirm" ]]
          then 
            password=$new
            echo "Password Reset Successfull. Time: $(date)" >> trans.txt
            > password.txt
            echo "$new" >> password.txt
            echo Password Reset Successfull
            break
          else 
            echo New Password and Confirm Password Mismatched
            continue
          fi
        else 
          echo Password Incorrect
          continue
        fi
      done
    ;;

    9)
      echo 1. Echo 1
      echo 2. Echo 2
      echo 3. Check Balance
      echo 4. Deposit Amount
      echo 5. Withdraw
      echo 6. Statement
      echo 7. My Account
      echo 8. Change Password
      echo 9. Display Menu Again
      echo 0. Exit
    ;;
      
    0)
      break;
    ;;
    *)
      echo Wrong Input
    ;;
  esac
done
echo
echo Thank You For Using Me
