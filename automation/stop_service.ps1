$cnt = 1

	
	while($cnt -le 1){
		$wf_path = 'E:\fix\_bio\sw\FaceMatch_Server_Wf18_' + $cnt
		$wf_bin = $wf_path + '\bin'
		$wf_deployment = $wf_path + '\standalone\deployments'
		$wf_server_log = $wf_path + '\standalone\log'
		$wf_app_log = $wf_bin + '\logs'
		$log_backup = 'E:\fix\_bio\sw\log_backup'
		
		
		
		#The below steps checks the status of the service.
		$ServiceName = 'FacMatch_Server_0' + $cnt
		$serviceStat = Get-Service -Name $ServiceName
		write-host $serviceStat.status
		
		#The below steps stops the service.
		$id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$ServiceName'" | Select-Object -ExpandProperty ProcessId
		write-host "$ServiceName $id"
		taskkill /PID $id /F /T
		Start-Sleep -Seconds 20
		  
		$serviceStat.Refresh()
		
		if ($serviceStat.Status -eq 'Stopped')
		{
			write-host "$ServiceName Service completely stopped."
		}
		else
		{
			write-host "$ServiceName Service was not stopped. Kindly check"
		}
		$cnt = $cnt + 1
		
		write-host "=============================================="
		Start-Sleep -seconds 20
	}
	Start-Sleep -seconds 30
	$cnt = 1
