<?php


$dpointer = opendir('stocks/preview');
$excludes = array (
						'.'
						,'..'
						,'.svn'
						,'Thumbs.db'
						,' '
					);
while (false !== ($file = readdir($dpointer))) {
	if (in_array($file, $excludes)) continue;
	$dir[] = $file;
}


foreach ($dir as $image){
	$source = "stocks/preview/$image";
	$dest = "newPreviews/$image";

	// find the image size and then center
	$t = exec ("identify $source ");
	preg_match ( '/[0-9]*x[0-9]*/' , $t , $matches );
	$sizes= explode("x", $matches[0]);
	$sizes['width'] = $sizes[0];
	$sizes['height'] = $sizes[1];
	
	$point1 = ($sizes['height']/2)-25 ;
	$point2 = ($sizes['width']/2)-140;
	$point3 = ($sizes['height']/2)+25;
	$point4 = ($sizes['width']/2)+140;
	
	
	$t = exec ("convert $source -draw \"rectangle $point2,$point1 $point4,$point3 \"  -background black $dest ");
	$t = exec ("convert $dest -fill white -draw \"text ".($point2+25).",".($point3-25)." '$image' \"  $dest ");
	//if ($image == $dir[0]) break;
}
print_r("done");
 