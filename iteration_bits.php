<?php

function array_search_recursive($needle, $haystack){
	$path=array();
	foreach($haystack as $id => $val)
	{

		if($val === $needle)
		$path[]=$id;
		else if(is_array($val)){
			$found=array_search_recursive($needle, $val);
			if(count($found)>0){
				$path[$id]=$found;
			}
		}
	}

	return array_keys($path);
}




$obj = (object) $obj;
$obj->counter = (int) 0;
$newArray = new $obj ;

function iterateMe($array){ 
	foreach ($array as $key => $value){
		if (is_array($value)){
			$newArray->$key = $key;
			iterateMe($value);
		} else {
			$newArray->$key = $key;
		}
	}
	return $newArray;
}


?>