<?php

class it{
	
	
	function readDir($dir){
		$handle = opendir($dir);
		
		while (false !== ($filename = readdir($handle))) {
	    	if ($filename =='.' or $filename =='..' or $filename[0]=='.'){
	    		continue;
	    	}
	    	
			if (is_dir($dir."/".$filename)){
				$this->readDir($dir."/".$filename);
				continue;
			}
			
	    	$filesize = filesize($dir."/".$filename);
	    	$this->writeFileToLog($filename , $filesize);
	    }
	    
	    closedir($handle);
	}
	
	function writeFileToLog($filename, $bytesize){
		$fp = fopen("versioning.log", "a+");
		fwrite($fp, $filename . " - ". $bytesize ."\r\n");
		fclose($fp);
	}
	
}// end of class

$dir = dirname(__FILE__);
$it = new it();
$it->readDir($dir);


?>
