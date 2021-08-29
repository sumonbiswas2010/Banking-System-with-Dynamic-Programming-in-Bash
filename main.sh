Print ()
{
  echo $1
}

Min()
{
  if(($1<$2))
  then return $1
  else return $2
  fi
}

Min 6 4
Print $?
#echo $?

