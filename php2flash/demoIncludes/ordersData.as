

/*
 * ===========================================================
 * This whole file was deleted by svn ...which is always a pleasant thing.
 * Thanks SVN!!!!
 * ============================================================
 */

/*
 * Array of objects that returna MyCart
 * note for self: Cab_Get_Orders_For_Passenger_By_UpID
 */
public function getOrderHistory():*{
		var result = new Object;
		result.data = (
		               {
		            	  'OrderStatus':0, 
		            	  'OrderPackageKey' : 39,
                          'PackageDescription' : '8x5 Vertical Color Print',
                          'TotalPrice' : 9.95
		               },
		               {
		            	  'OrderStatus':0, 
		            	  'OrderPackageKey' : 5,
                          'PackageDescription' : '8x5 Vertical Color Print',
                          'TotalPrice' : 9.95
		               }
		              );
}


public function getOpenOrderList():*{
	var result = new Object;
	result.data = (
	               {
	            	   33 : 
	            	   {
	                       'Location' : 'cab_1',
	                       'Date' : '2009-02-02 19:03:07.090',
	                       'OrderPackage' : 
	                           {
	                               0 : 
	                                   {
	                                       'OrderPackageKey' : 39,
	                                       'PackageDescription' : '8x5 Vertical Color Print',
	                                       'TotalPrice' : 9.95,
	                                       'OrderDetail' : 
	                                           {
	                                               0 : 
	                                                   {
	                                                       'OrderDetailKey' : 39,
	                                                       'Quantity' : 1,
	                                                       'ProductTypeId' : 1,
	                                                       'ProductId' : 25,
	                                                       'BulkImageID' : 5534,
	                                                       'Price' : 9.9500,
	                                                       'Datestamp' : '2009-02-02 19:05:11.090',
	                                                       'FullURLPath' : 'http://imagestage.cabinetuk.com/PictureOrderRendering-DBv2/285/Stairs2/',
	                                                       'PreviewImage' : 'General_1763'
	                                                   }

	                                           }

	                                   }

	                           }

	                   },

	               32 : 
	                   {
	                       'Location' : 'cab_1',
	                       'Date' : '2009-01-30 17:16:21.217',
	                       'OrderPackage' : 
	                           {
	                               0 : 
	                                   {
	                                       'OrderPackageKey' : 5,
	                                       'PackageDescription' : '8x5 Vertical Color Print',
	                                       'TotalPrice' : 9.95,
	                                       'OrderDetail' : 
	                                           {
	                                               0 : 
	                                                   {
	                                                       'OrderDetailKey' : 5,
	                                                       'Quantity' : 1,
	                                                       'ProductTypeId' : 16,
	                                                       'ProductId' : -16,
	                                                       'BulkImageID' : 5534,
	                                                       'Price' : 9.9500,
	                                                       'Datestamp' : '2009-01-29 17:38:35.000',
	                                                       'FullURLPath' : 'http://imagestage.cabinetuk.com/PictureOrderRendering-DBv2/285/Stairs2/',
	                                                       'PreviewImage' : 'General_1763'
	                                                   }

	                                           }

	                                   },

	                               1 : 
	                                   {
	                                       'OrderPackageKey' : 6,
	                                       'PackageDescription' : '8x5 Vertical Color Print',
	                                       'TotalPrice' : 15.00,
	                                       'OrderDetail' : 
	                                           {
	                                               0 : 
	                                                   {
	                                                       'OrderDetailKey' : 6,
	                                                       'Quantity' : 1,
	                                                       'ProductTypeId' : 16,
	                                                       'ProductId' : -16,
	                                                       'BulkImageID' : 5534,
	                                                       'Price' : 15.0000,
	                                                       'Datestamp' : '2009-01-29 17:52:51.280',
	                                                       'FullURLPath' : 'http://imagestage.cabinetuk.com/PictureOrderRendering-DBv2/285/Stairs2/',
	                                                       'PreviewImage' : 'General_1763'
	                                                   }

	                                           }

	                                   },

	                               2 : 
	                                   {
	                                       'OrderPackageKey' : 10,
	                                       'PackageDescription' : '8x5 Vertical Color Print',
	                                       'TotalPrice' : 9.95,
	                                       'OrderDetail' : 
	                                           {
	                                               0 : 
	                                                   {
	                                                       'OrderDetailKey' : 10,
	                                                       'Quantity' : 1,
	                                                       'ProductTypeId' : 16,
	                                                       'ProductId' : -16,
	                                                       'BulkImageID' : 5534,
	                                                       'Price' : 9.9500,
	                                                       'Datestamp' : '2009-01-29 17:59:29.687',
	                                                       'FullURLPath' : 'http://imagestage.cabinetuk.com/PictureOrderRendering-DBv2/285/Stairs2/',
	                                                       'PreviewImage' : 'General_1763'
	                                                   }

	                                           }

	                                   }


	                           }

	                  }
	           
	               }
	              );
	
}