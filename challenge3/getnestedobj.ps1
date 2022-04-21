  #Author:Lakshmikanth
  #took reefernce of https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/get?view=azure-devops-rest-6.0 to get the object
  $obs=""
  #this are the keys with a array
 $key=@('lastChangedBy','_links','avatar')
  $obs="`$actobj"
 foreach($val in $key){
 $obs+="."+$val
 }
 #invoke expression
 Invoke-Expression $obs