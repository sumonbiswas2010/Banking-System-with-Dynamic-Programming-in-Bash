#install-pkg bc
agents=(01672836364 01935640880)

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
    Withdraw
    return;
  fi
 done
 echo No Agents Found
}

Withdraw()
{
  read -p "Enter Withdraw Amount: " a
  a=$(  Number $a )
  if(($a==0))
  then echo Please Enter a Valid Amount
  else
    if (( $(echo "$balance > $a" |bc -l) )); then
    #then
      balance=`echo $balance-$a | bc`
      echo Your Current Balance is $balance;
    else echo Insufficient Balance. Please try again.
    fi
  fi
}
name="Sumon Biswas"
account='181002087'
password='secret'
balance=1000.00;
echo Hi $name, Good Day
echo


switch=1;

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
      Check_Pass
      ok=$?
      if(($ok==1))
      then echo Your Current Balance is $balance;
      else echo Wrong Password
      fi
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
        Withdraw
      fi
    ;;

    8)
      Check_Pass
      ok=$?
      if(($ok==1))
      then
        read -p "Enter New Password: " new 
        read -p "Confirm Password: " confirm
        if [[ "$new" == "$confirm" ]]
        then 
          password=$new
          echo Password Reset Successfull
        else echo New Password and Confirm Password Mismatched
        fi
      else echo Password Incorrect
      fi
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
