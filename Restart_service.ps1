$cnt = 1
#while($true){
	
	while($cnt -le 2){
		$wf_path = 'E:\fix\_bio\sw\BoW_Server_Wf18_' + $cnt
		$wf_bin = $wf_path + '\bin'
		$wf_deployment = $wf_path + '\standalone\deployments'
		$wf_server_log = $wf_path + '\standalone\log'
		$wf_app_log = $wf_bin + '\logs'
		$log_backup = 'E:\sfx\_bio\sw\log_backup'
		
		#if( (Test-Path "$wf_bin\hs_err*.*") -OR ($serviceStat.Status -eq 'Stopped')) {
		$ServiceName = 'BoW_Server_0' + $cnt
		$serviceStat = Get-Service -Name $ServiceName
		write-host $serviceStat.status
		if ($serviceStat.Status -ne 'Stopped')
		{
			$id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$ServiceName'" | Select-Object -ExpandProperty ProcessId
			write-host "$ServiceName $id"
			taskkill /PID $id /F /T
			Start-Sleep -Seconds 20
		}
		  
		Remove-Item "$wf_bin\hs_err*.*"
		  
		#The below line backups up the server logs
		#Remove-Item "$wf_server_log\."
		$current_time = Get-Date -Format "dd-MM-yyyy-HH-mm"
		$move_destination = $log_backup + "\" + $ServiceName + "\" + $current_time
		mkdir $move_destination
        Move-Item -Path "$wf_server_log/*" -Destination $move_destination
		  
		#The below line backups up the application logs
		#Remove-Item "$wf_app_log\."
        Move-Item -Path "$wf_app_log/*" -Destination $move_destination
		  
		Remove-Item "$wf_deployment\*.deployed"
		Remove-Item "$wf_deployment\*.failed"
		Remove-Item "$wf_deployment\*.undeployed"
		  
		Start-Sleep -Seconds 10
		  
		Start-Service $ServiceName
		$serviceStat = Get-Service -Name $ServiceName
		write-host $serviceStat.status
		write-host 'Service starting'
		  
		Start-Sleep -seconds 20
		  
		$serviceStat.Refresh()
		while( -NOT( (Test-Path "$wf_deployment\*.deployed") -AND ($serviceStat.Status -eq 'Running') ) ){
			 Start-Sleep -seconds 5
		}
		  
		Write-Host "$ServiceName Service is now Running"
		Remove-Item "$wf_deployment\*.failed"
		  
		#}else{
		#  write-host "There is no crash report for $wf_path"
		#}
		
		$cnt = $cnt + 1
		
		write-host "=============================================="
		Start-Sleep -seconds 20
	}
	Start-Sleep -seconds 120
	$cnt = 1
#}
