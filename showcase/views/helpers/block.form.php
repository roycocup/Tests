<?php

function smarty_block_form($params, $content, Smarty $smarty, &$repeat)
{
	if (!$repeat) {
		$action	= $_SERVER["REQUEST_URI"];
		$method	= "POST";
		
		$str	= "<form ";
		
		while (list($attribute, $value) = each($params)) {			
			$str	.= $attribute . "=" . "\"" . $value . "\" ";
			
			if ($attribute == "action"){
				$action	= null;
			}
			
			if ($attribute == "method"){
				$method	= null;
			}
		}
		
		if ($method){
			$str	.= "method=" . "\"" . $method . "\" ";
		}
		
		if ($action){
			$str	.= "action=" . "\"" . $action . "\" ";
		}
		
		$str	.=">\n";
		
		$str	.= $content;

		$str	.= "</form>";

		echo $str;
	}
}