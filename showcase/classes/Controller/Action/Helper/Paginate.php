<?php

/* **********************************************************
	Paginate Class
	
	- breaks down result sets into pages
	- returns an array of page numbers with corresponding offset and current value
	
*********************************************************** > */

class Prometheus_Controller_Action_Helper_Paginate extends Zend_Controller_Action_Helper_Abstract {
	
	public function PaginateData($totalitems, $itemsperpage, $offset) {
	
		$counter		=		0;
		$arraycounter	=		0;
		$itemoffset		=		0;
		$outputArray	=		array();
		$pagecount		=		floor($totalitems / $itemsperpage);
		
		// check for extra items that slip over the last page and add an extra page if they exist
		if (($totalitems % $itemsperpage) != 0) { 
			$pagecount++; 
		}	
		
		if ($pagecount > 1) {
			
			// add previous button if not the first item
			if ($offset != 0) {
				$outputArray[$arraycounter]['content']		=	"&laquo; Prev";
				$outputArray[$arraycounter]['offset']		=	($offset - $itemsperpage);
				$outputArray[$arraycounter]['current']		=	0;
				$arraycounter++;
			}
			while ($counter < $pagecount) {
			
				// calculate new offset
				if ($counter != 1) {
					$itemoffset		=	($itemoffset + $itemsperpage);
				}
				
				$outputArray[$arraycounter]['content']		=	($counter + 1);
				$outputArray[$arraycounter]['offset']		=	($itemsperpage * $counter);
				
				// if offset matches the current item, then set current item
				if ($offset == ($counter * $itemsperpage)) {
					$outputArray[$arraycounter]['current']		=	1;
				} else {
					$outputArray[$arraycounter]['current']		=	0;
				}
				
				$counter++;
				$arraycounter++;
				
			}
			
			// add next button if not the last item
			if (($offset + $itemsperpage) <= $totalitems) {
				$outputArray[$arraycounter]['content']		=	"Next &raquo;";
				$outputArray[$arraycounter]['offset']		=	($offset + $itemsperpage);
				$outputArray[$arraycounter]['current']		=	0;
			}
		
		}
	
		// spit the result out as an array
		return $outputArray;
	
	}
	
}