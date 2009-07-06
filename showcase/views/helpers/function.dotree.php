<?php


function smarty_function_dotree($params, Smarty $smarty)
{
	$string	= "";
	if ($tree = $params['tree']) {
		$string	.= '<ul><li class="top"><a href="'.HOME_URL.'">Home</a></li></ul>';
		$string	.= displayChildren($smarty, $tree);
	}
	return $string;
}

function displayChildren(Smarty $smarty, $tree)
{	
	$templateVars 		= $smarty->get_template_vars();
	$currentController	= strtolower($templateVars['__ZF__']['controller']);
	$currentAction		= strtolower($templateVars['__ZF__']['action']);

	$string	= "";

	$string	.= '<ul>';
	foreach($tree as $child){
		// if it is a root
		if (null === $child->inherits){
			$string	.= '<li>';
			$string	.= '<div>' . $child->name . '</div>';
			if (is_array($child->children)){
				$string	.= displayChildren($smarty, $child->children);
			}
			$string	.= '</li>';
		}else{
			if (!is_array($child->children)){
				$string	.= '<li>';
				if ("category" === $currentController && $child->identifier === $currentAction) {
					$string	.= '<div class="on">'.$child->name ." (". $child->howmany.")".'</div>';
				} else {
					$string	.= '<a href="/category/'.$child->identifier.'">'.$child->name ." (". $child->howmany.")".'</a>';
				}
				$string	.= '</li>';
			}else{
				$string	.= '<li>';
				$string	.= '<div>' . $child->name . '</div>';
				if (is_array($child->children)){
					$string	.= displayChildren($smarty, $child->children);
				}
				$string	.= '</li>';
			}
		}
	}
	$string	.= '</ul>';
	
	return $string;
}