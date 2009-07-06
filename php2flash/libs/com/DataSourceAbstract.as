package com.cabinetuk.datasource{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.cabinetuk.model.data.DataIterator;
	import com.cabinetuk.model.data.DataObj;
	import com.cabinetuk.utils.events.*;
	
	
	/**
	 * Includes common functions for DataSources, NOT DIRECTLY to be instantiated ! 
	 */	
	public class DataSourceAbstract{
		
		public var dispatcher:EventDispatcherObj = new EventDispatcherObj();
		protected var loader:BulkLoader;
		protected var _onAllCompleteFunction:Function;
		protected var _calls:DataIterator = new DataIterator();
		
		public function DataSourceAbstract(){
			this.loader = new BulkLoader(BulkLoader.getUniqueName());
		}
		
		/**
		 * Various DataSource calls can be done with this generic function,
		 * Once the data is ready, we call the return function with the return data as it's only argument
		 * Real implementation is in DataSourceDemo and DataSrouceWebServices classes
		 * @param id unique id for each call
		 * @param onComplete this function will be called, once the data is ready
		 * @param dataSrcFunction the real webservice function name  
		 * @param params coma separated string of the webservice function's params
		 */		 		
		public function addCall(id:String, dataSrcFunction:String, params:String):void{
		}
		
		
		/**
		 * Returns the data received 
		 * @param id
		 * @return DataObj
		 */		
		public function getData(id:String):DataObj{
			return new DataObj();
		}
		
		public function onComplete(id:String, listener:Function):void{
		}
		
		public function onAllComplete(onAllCompleteFunc:Function):void{
		}
		
		public function start():void{
			this.loader.start();
		}
		
		protected function clearUpAfterAllComplete():void{
			
		}
		
		/*
		 * ================================================================================================
		 * NOTE: PLEASE DO NOT REMOVE THE COMMENTING FOR NOW... ILL TAKE IT OFF WHEN ITS READY ON DEMO
		 * ================================================================================================
		 */
		/*
		public function getServices(...params):void{
			trace("THIS IS getServices !! with: " + params.toString());
		}
		
		public function  getAvailableLanguages():Array{
			return new Array();
		}
		
		public function  addImageToOrder():void{
		}
		
		public function  addItemToOrder():void{
		}
		
		public function  deleteItemFromOrder():void{
		}
		
		public function  getCurrency():void{
		}
		
		public function getFAFImages(uniquePassengerID:String):Object{
			return new Array();
		}
		
		public function  getLatestStockImage():void{
		}
		
		public function  getLatestProPhotos(uniquePassengerID:String):Object{
			return new Object();
		}
		
		public function  getLatestStockImages():void{
		}
		
		public function  getOrderDetails():void{
		}
		
		public function  getOrderHistory():void{
		}
		
		public function  getOrderTotal():void{
		}
		
		public function  getPassengerDetails():void{
		}
		
		public function  getPickupTimes():void{
		}
		
		public function  getProductPrice():void{
		}
		
		public function  getProducts(imageID:int):Object{
			return new Object();
		}
		
		public function  getProPhotoImages():void{
		}
		
		
		public function  getStockImages():void{
		}
		
		public function  getTimeoutValue():void{
		}
		
		public function  isDeliveryAvailable():void{
		}
		
		
		public function  isOpenOrders():Boolean{
			return true;
		}
		
		public function  isStateroomNumberValid(nr:Number):Boolean{
			return true;
		}
		
		public function  isVoucherEnabled():Boolean{
			return true;
		}
		
		public function  saveOrder():void{
		}
		*/
	}
}