<?phpclass PushWorker{	public static function doPushDemo($astrContent,$anUnReadMsgCount =1)	{		$deviceToken = "210baf51 89f3c9b9 db1624a3 dd06773b f4b951b8 74f2da98 28c1b988 4f081762";
		$time = time();
		
		$apnsHost = 'gateway.sandbox.push.apple.com';
		
		$apnsPort = 2195;
		$apnsCert = 'ck.pem';
		
		$streamContext = stream_context_create();
		stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
		
		$apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 2, STREAM_CLIENT_CONNECT, $streamContext);
		if($apns)
		{
			echo "Connection Established<br/>";
			$payload = array();
			$payload['aps'] = array('alert' => $astrContent, 'badge' => $anUnReadMsgCount, 'sound' => 'default');
			$payload = json_encode($payload);
			$apnsMessage = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $deviceToken)) . chr(0) . chr(strlen($payload)) . $payload;
		
			print "sending message :" . $apnsMessage . "<br/>";
			print "sending payload :" . $payload . "<br/>";
			fwrite($apns, $apnsMessage);
		
		}
		else
		{
			echo "Connection Failed";
			echo $errorString;
			echo $error;
		}				fclose($apns);	}		public static function doPush($astrContent,$anUnReadMsgCount =1)
	{

		$time = time();
	
		$apnsHost = 'gateway.push.apple.com';
	
		$apnsPort = 2195;
		$apnsCert = 'ck.pem';
	
		$streamContext = stream_context_create();
		stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
	
		$apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 2, STREAM_CLIENT_CONNECT, $streamContext);
		if($apns)
		{
			echo "Connection Established<br/>";
			$payload = array();
			$payload['aps'] = array('alert' => $astrContent, 'badge' => $anUnReadMsgCount, 'sound' => 'default');			
			$payload = json_encode($payload);
			$apnsMessage = chr(0) . chr(0) . chr(32) . chr(0) . chr(strlen($payload)) . $payload;
	
			print "sending message :" . $apnsMessage . "<br/>";
			print "sending payload :" . $payload . "<br/>";
			fwrite($apns, $apnsMessage);
	
		}
		else
		{
			echo "Connection Failed";
			echo $errorString;
			echo $error;
		}
	
		fclose($apns);
	}
	
}PushWorker::doPushDemo("2013-03-17 02:54:07 塔里木石化化肥厂K411	 ZT4151 低报 ",3);?>