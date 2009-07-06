<?php

function smarty_function_print_registry($params, Smarty $smarty)
{
	$registry = Zend_Registry::getInstance();
	$searchValue = $params['assign'];
	foreach ($registry as $index => $value) {
		if ($index == $searchValue){
			echo "Registry index $index contains:\n";
			var_dump($value);
		}
		if($searchValue==''){
			echo "Registry index $index contains:\n";
			var_dump($value);
		}
	}
}