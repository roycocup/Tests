<?php

function smarty_function_categories($params, Smarty $smarty)
{ 
// foreach the object and put them in key
// have the option to print icons or words
	if (isset($params['obj']))
	{
		// foreach the object into a newarray with the category into the key so duplicates can 
		$cont = $params['obj'];
		$newArray = array();
		foreach ($cont->media as $value){
			$cat = $value->category->identifier;
			if (isset($params['icons']))
			{ 
				$newArray[$cat] = htmlentities("<img src='/images/icons/".$cat.".gif'> &nbsp;");
			}else
			{ 	
				$newArray[$cat] = $value->category->name;
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
				$string	.= "<li id='default'";
				$string .= $default;
				$string .= "><a href='javascript:;' onclick=\"tab(this, 'cont" . $cont->id . "_0', " . count($newArray) . ")\">All Media</a></li>";
				
				$i = 0;
				foreach ($newArray as $key=>$value){
					$i++;
					$string	.= "<li" . $selected . "><a href='javascript:;' onclick=\"tab(this, 'cont" . $cont->id . "_" . $i . "', " . count($newArray) . ")\">" . ucwords(strtolower($value)) . "</a></li>";
				}
				
				$string	.= "</ul>";

			break;
			
			default :
				$i = 0;
				foreach ($newArray as $key=>$value){
					$i++;
					if ($i>1) {
						$string	.= ' / '.$value;
					} else {
						$string	.= $value;
					}
					
				} 
			break;
		}
		
		echo $string;
	}
}

