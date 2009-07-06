<?php

function smarty_function_catIcons($params, Smarty $smarty)
{ 
// foreach the object and put them in key
// have the option to print icons or words
	if (isset($params['obj']))
	{
		// foreach the object into a newarray with the category into the key so duplicates can 
		$cont = $params['obj'];
		$newArray = array();
		foreach ($cont->media as $value){
			$cat = $value->category->name;
			if (isset($params['icons']))
			{ 
				$newArray[$cat] = htmlentities("<img src='/images/icons/".$value->category->identifier.".gif'> &nbsp;");
			}else
			{ 	
				$newArray[$cat] = $cat;
			}
		}
		
		$type	= isset($params['type']) ? $params['type'] : NULL;
		$string	= "";
		
		switch ($type) {
			case 'icons':
				foreach ($newArray as $value){
					$value = html_entity_decode($value);
					$string	.= $value;
				}	
			break;
			
			case 'tabs':
				$style		= " class='on' ";
				$selected	= isset($params['select']) ? $style : NULL;
				$default	= (!$selected) ? $style : NULL;
				
				$string	.= "<ul class='tabs'>";
				$string	.= "<li";
				$string .= $default;
				$string .= "><a href='javascript:;'>All Media</a></li>";
				
				foreach ($newArray as $key=>$value){
					$string	.= "<li" . $selected . "><a href='javascript:;'>" . ucwords(strtolower($key)) . "</a></li>";
				}
				
				$string	.= "</ul>";

			break;
			
			default :
				$i = 0;
				foreach ($newArray as $key=>$value){
					$i++;
					if ($i>1) {
						$string	.= ' / '.$key;
					} else {
						$string	.= $key;
					}
				} 
			break;
		}
		
		echo $string;
	}
}

