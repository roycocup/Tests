<?php

/*
 * instructions: 
 * configure the sourcefiles. 
 * open cmd. 
 * go to this file dir. 
 * type c:\php5\php.exe differ.php
 */

//time start this
$timeStart = time();

/*
 * This will give you
 * what files they have that are OUT-OF-DATE
 * what files do they have that WE DONT
 */
$input1 = 'sourcefiles/issue557.txt'; // this is them
$input2 = 'sourcefiles/090604.txt'; //reference must be up to date ... THIS IS US


/*
 * uncommneting and running this will give you:
 * What have we got that THEY DONT or is OUT-OF-DATE
 */
/*
$input1 = 'sourcefiles/rod-090303.txt'; //this file is us
$input2 = 'sourcefiles/katya-090303.txt'; //this file is them
*/

$diffsFile = "diffs.txt";
$sourceFile = "diffs.txt"; 
$mainFolders = "c:/dev/kioskV3/";
$packageDir = "./package/";

$diffArray = array();
$matches = array();

//file 1 setup
$fileops1 = new fileOperations($input1);
$file1Array = explode ("\n", ($fileops1->getContents()));

//file 2 setup
$fileops2 = new fileOperations($input2);
$file2Array = explode ("\n", ($fileops2->getContents()));

//setup
$endOfArray = count($file1Array)-1;
ob_start();

//get the first line on 1
for ($i=0; $i <= $endOfArray; $i++){	
	
	$flagFound = 0;
	
	foreach ($file2Array as $lineFrom2){
		
		if ($file1Array[$i] == $lineFrom2){ 
			$fileops1->writeToFile('equals.txt', $file1Array[$i]);
			echo "Found match \n";
			ob_flush();
			$flagFound = 1;
		}
		
	}
	
	if ($flagFound == 0){
		echo "File not equal in target : $i \n";
		ob_flush();
		$fileops1->writeToFile($diffsFile, $file2Array[$i]);
	}
	
	
}


//time start this
$timeEnd = time();
$timeExecution = ($timeEnd - $timeStart)/60;   
echo "Completed successfully in $timeExecution minutes \n";
ob_flush();



echo "Packing up files... \n";
ob_flush();

//create the package folder if we dont have it
if (!is_dir($packageDir)){
	@mkdir($packageDir); 
}

//file diff setup
$fileops3 = new fileOperations($diffsFile);
$file3Array = explode ("\n", ($fileops3->getContents()));

foreach ($file3Array as $diffLine){
	//take the size off
	$diffLineName = explode(" - ", $diffLine);
	
	//divide into directories
	$diffFileDirs = explode("/", $diffLineName[0]);
	
	//to access the name of the file we need the last one of this array
	$last = count($diffFileDirs)-1;
	
	//
	for ($j=1; $j <= $last-1; $j++){
		
		//setting the directory string
		$dir .= $diffFileDirs[$j]."/";
		
		if (is_dir($packageDir.$dir)){
			continue;
		} else {
			@mkdir($packageDir.$dir);
		}
	}
	
	//copy the final file to it
	//$fileops1->writeToFile("copythis.txt", dirname(__FILE__) . "/packages/".$dir.$diffFileDirs[$last]."\r");
	copy ("c:/dev/kioskv3/". $dir.$diffFileDirs[$last], dirname(__FILE__) . "/package/".$dir.$diffFileDirs[$last]);
	
	//unset the directory string to be reused in next interation
	$dir = "";
}

echo "Completed \n";
ob_end_flush();



class fileOperations {
	
	public $fileName;
	public $fopenHandler;
	public $fileContents;
	
	public function __construct($fileName){
		$this->fileName = $fileName;
		$this->fopenHandler = fopen($this->fileName, 'r');
	}
	
	public function getContents() {
		$this->fileContents = fread($this->fopenHandler, filesize($this->fileName));
		fclose($this->fopenHandler); 
		return $this->fileContents;
	}
	
	public function writeToFile($file, $str){
		$fp = fopen($file, "a+");
		fputs($fp, $str . "\n");
	}
	
	
}

