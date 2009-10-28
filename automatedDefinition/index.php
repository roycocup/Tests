<?php

$bookFile 			= 'BookDefinition.xml';
$productsFolder 	= './Products'; 


$bookDef = simplexml_load_file($bookFile);

$pageNumber = 1;
foreach ($bookDef->page as $page){ 
	//book definition page is access by $page[$pageNumber -1]
	//get the corresponding product xml for this page
	//alter the values on the bookDef xml 
}

?>