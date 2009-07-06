<?php
error_reporting(E_ALL);
if (!$_POST){
	
} else {

	//requires
	require ("classes/fileoperations.php");
	require ("classes/buildPhing.php");
	
	//vars 
	$configFile = "build.properties";
	
	//classes
	$fileOps = new fileoperations();
	
	//preparing data from form
	if (""==$_POST['destination']){return false;}
	$srcdir = $_POST['destination'];
	
	
	
	// writing  the config file
	$fileOps->setFileName($configFile);
	
	$fileOps->writeToFile('#Properties for the installer of KioskV3 Server');
	$fileOps->writeToFile('#Project properties');
	$fileOps->writeToFile('package 	= ${phing.project.name} ');
	$fileOps->writeToFile('version 	= 1.0.0 ');
	$fileOps->writeToFile("tempBuildDir 	= ./tempBuildDir");
	$fileOps->writeToFile("kiosk.tar.name 	= kiosk".time().".tar.gz");

	
	$fileOps->writeToFile('#User inputs');
	$fileOps->writeToFile("srcdir = $srcdir");
	
	//executing phing
	//$r = exec('phing ');
	//echo $r;
	//echo "<br/>";
	
	require_once('phing2/phingWeb.php');
	print_r($_POST); die;
	//cleanup
	@unlink("build.properties");
	
	//informing of completion
	echo "done";
}


?>
<html>
<head>
<script language="JavaScript">
 function GetDirectory() {
  strFile = document.MyForm.MyFile.value;
  intPos = strFile.lastIndexOf("\\");
  strDirectory = strFile.substring(0, intPos);
  alert(strFile + '\n\n' + strDirectory);
  return false;
 }
</script>
</head>
<body>
	<div id="main">
		<div id="top"><h1>Welcome to Kiosk Server Version 3 Installer</h1></div>
		<div id="middle">
			<form action="index.php" method="POST">
				Directory where to install the server:
				<input type="text"  name="destination" /><br>
				<input type="hidden" value="go clicked" name="ready" onClick="GetDirectory();" />
				<input type="submit" value="Go!" /><br>
			</form>
		</div>
		
		<div id="footer">copyright @ 2009</div>
		
	</div>
</body>
</html>
