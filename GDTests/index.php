<?php
error_reporting (0);

$imageHandler = imagecreatefrompng('alpha.png');

$imageTotalWidth = imagesx($imageHandler);
$imageTotalHeight = imagesy($imageHandler);


//$i will come down a line 
for ($i = 0; $i < $imageTotalHeight; $i++ ){
	
	//$j moves lateraly one pixel
	for ($j = 0; $j < $imageTotalHeight; $j++ ){
		
		//get the colours of that pixel (line, row)
		$pixel = imagecolorsforindex($imageHandler, imagecolorat($imageHandler, $i, $j));
		
		//if you found a black pixel recor where it is.
		if ($pixel['red'] < 1){
			//line, row
			$blackPixs[$j][$i] = '';		
		}
	}
}
 
//lets identify the coordinates for this now.
$i = 0;
foreach($blackPixs as $k=>$lines){
	if ($i==0){
		$topLeftLine = $k;
	}
	$i++;
	$bottomRight = $k; 
}

$i=0;
foreach($blackPixs as $lines){
	foreach($lines as $k=>$rows){
		if ($i==0){
			$left = $k;
		}
		$i++;
		$right = $k; 
	}
}

$coordinates = array('Top'=>$topLeftLine, 'Bottom'=>$bottomRight, 'Left'=>$left, 'Right'=>$right);
print_r($coordinates);

?>