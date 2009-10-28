<?php
include 'adodbconnect.php';

$bookDefinitionTable = 'PB_Book_Definition_CabUK';

$xmlDoc = new DOMDocument();
$xmlDoc->load("BookDefinition.xml");

$x = $xmlDoc->documentElement;
// this array will hold all the insert script
$insertArray = array();

foreach ($x->childNodes AS $page) {
	if($page->hasChildNodes()) {
		foreach ($page->childNodes AS $template) { 
			if($template->hasChildNodes()) {
				foreach ($template->childNodes AS $StockImageName) {
					if($StockImageName->hasAttributes()) {
						if($template->getAttribute("id") == 'none') {
							$templateId = 0;
						} else {
							$templateId = $template->getAttribute("id");
						}
						if($template->getAttribute("default") == 'true' || $template->getAttribute("default") == 'TRUE') {
							$templateDefault = 1;
						} else {
							$templateDefault = 0;
						}
						if($StockImageName->getAttribute("filename") == "none") {
							$stockImageFilename = 0;
						} else {
							$stockImageFilename = "'".$StockImageName->getAttribute("filename")."'";
						}						
						$insertArray[] = "INSERT INTO $bookDefinitionTable (PhotobookID, PageNumber, TemplateID, Template_Default, StockImageName) VALUES (1,". $page->getAttribute("number").", ".$templateId.", ".$templateDefault.", ".$stockImageFilename.");";
					}					
				}
			}
		}	
	}
}

foreach($insertArray as $value) {
	print $value . "<br/>";
	//$db->
}

?> 