
	
#SQl Connection 	
	$params = @{

  'Database' = 'azuredb'

  'ServerInstance' =  'azuredbtest01.database.windows.net'

  'Username' = 'azuredbadmin'

  'Password' = 'azuredb9#'

  'OutputSqlErrors' = $true

  'Query' = " insert into Status (Server_status, site_status, Date) values ('Running', 'Running', getdate())"

  }
	
	
	
	#Getting the status details of the VM and store it in a file
	Get-AzVM -ResourceGroupName "ResourceGroup01" -Name "VM01" -Status > c:\Users\Chamika.Nirmani\Downloads\initstatus.txt
	
	#decalre a variable for the outputfile path 
	$initstatus = "c:\Users\Chamika.Nirmani\Downloads\initstatus.txt"
	
	#filterout the status from the details 
	
	
	$powerstate01= Get-Content $initstatus | Select-String "PowerState"
	
	
	#echo $powerstate01
	#echo $powerstate02
	
	
	 if ( $powerstate01 -like "*running" )
	  {
	   echo "VM is running "
	   
	   [system.diagnostics.process]::start("msedge","http://13.90.224.74/mysite/") >c:\Users\Chamika.Nirmani\Downloads\iis.txt
	   
	  
		Invoke-Sqlcmd  @params
  
  
	   
	 }
	  
	  
	 elseif(  $powerstate01 -like "*deallocated" ) 
	 { 
		 echo $powerstate01 " VM is off. Starting the VM"
		 
		
		
	#starting the VM
		 Start-AzVM -ResourceGroupName "ResourceGroup01" -Name "VM01"

	#checking the status of the vm again
		Get-AzVM -ResourceGroupName "ResourceGroup01" -Name "VM01" -Status > c:\Users\Chamika.Nirmani\Downloads\status02.txt
		$status02 = "c:\Users\Chamika.Nirmani\Downloads\status02.txt"
		$Startingstatus= Get-Content $status02 | Select-String "VM running"
		echo $startingstatus
	
	#checking the website 	
		[system.diagnostics.process]::start("msedge","http://13.90.224.74/mysite/") >c:\Users\Chamika.Nirmani\Downloads\iis.txt
		
	#wririting data to sql 
		Invoke-Sqlcmd  @params
  
  
		
	 }
	 
	 
	 else 
	 {
		  echo "system error! please contact the system admin"
		  #send an email to support
	 }
	 
	 
	