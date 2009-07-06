package com.cabinetuk.datasource
{
	import com.cabinetuk.Registry;
	import com.cabinetuk.model.data.DataObj;
	import com.cabinetuk.utils.events.*;
	
	public class DataSourceController{
		
		public var dataSource:DataSourceAbstract;

		public function DataSourceController(){
			_setDataSource();
		}
		
		/**
		 *Checks for online connection, sets the DataSource (DataSourceWebServices OR DataSourceDemo)
		 * 
		 */		
		private function _setDataSource(isDemo:Boolean = true):void{
			
			var reg:Registry = Registry.getInstance();
			//trace("DataSourceController setDS: " +  reg.isDemoMode);
			
			//if we are online we use WebServices
			if(reg.isDemoMode==false){
				dataSource = new DataSourceWebServices();
			}
			else{ //we use the demo
				dataSource = new DataSourceDemo();
			}
		}
		
		/**
		 * Delegates the DataSource calls to the this.dataSource call() function,
		 * Once the data is ready, it fires an event, which can be catched with onComplete
		 * @param id unique id for each call
		 * @param onComplete this function will be called, once the data is ready
		 * @param dataSrcFunction the real webservice function name  
		 * @param params these will be passed to the webservice function,
		 * Note: params are converted to a comma separated string, so only primitive types are accepted !!
		 */		
		public function addCall(id:String, dataSrcFunction:String,...params):void{
			dataSource.addCall(id, dataSrcFunction,params.toString());
		}

		public function onComplete(id:String, onCompleteFunction:Function):void{
			dataSource.onComplete(id,onCompleteFunction);
		}
		
		public function onAllComplete(onAllCompleteFunc:Function):void{
			dataSource.onAllComplete(onAllCompleteFunc);
		}
		
		public function getData(id:String):DataObj{
			return this.dataSource.getData(id);
		}
		
		public function start():void{
			this.dataSource.start();
		}
		
	}
}