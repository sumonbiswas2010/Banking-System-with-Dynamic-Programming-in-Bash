#install-pkg bc

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
 echo $1
}
name="Sumon Biswas"
account='181002087'
password='secret'
balance=1000.00;
echo Hi $name, Good Day
echo


switch=1;

while(($switch!=0))
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
      read -p "Enter Password: " pass
      if [[ "$pass" == "$password" ]]
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
        read -p "Enter Withdraw Amount: " a
        a=$(  Number $a )
        if(($a==0))
        then echo Please Enter a Valid Amount
        else
          balance=`echo $balance-$a | bc`
          echo Your Current Balance is $balance;
        fi
        
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



Min()
{
  if(($1<$2))
  then return $1
  else return $2
  fi
}

Min 6 4
#echo $?