package com.cabinetuk.datasource{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	import com.cabinetuk.model.data.DataObj;
	import com.cabinetuk.model.data.StatusObj;
	import com.cabinetuk.utils.CustomError;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * Supports data transit with WebServices, NOT to be instatiated directly, use DataSourceController instead
	 */	
	public class DataSourceWebServices extends DataSourceAbstract{
		
		public function DataSourceWebServices(){
			super();
		}
		
		override public function addCall(_id:String, callFunction:String, params:String):void{
			
			//convert the parameters to an Array
			//var parameters:Array = params.split(",");
			/*
			//TODO: implement the real call with the callFunction and the params
			switch(callFunction){
				case "getAvailableLanguages":
					this.loader.add("http://localhost/test/getAvailableLanguages.php",{id:_id, type:BulkLoader.TYPE_TEXT});
				break;
				default:
					this.loader.add("http://localhost/test/clientTest.php",{id:_id, type:BulkLoader.TYPE_TEXT});
				break;
			}*/
			// you can also use a URLRequest object , this will load from a POST request
			var postRequest : URLRequest = new URLRequest("http://localhost/kioskv3/webservices/clients/requests_ws.php");
			postRequest.method = "POST";
			var postData : URLVariables = new URLVariables();
			postData[callFunction] = params;
			postRequest.data = postData;
			this.loader.add(postRequest,{id:_id, type:BulkLoader.TYPE_TEXT});
						
			//Store the details of the call for later to be able to remove the listener later
			var data:DataObj = new DataObj();
			data.id = _id;
			data.call = callFunction + "("+params+")";
			this._calls.addElem(data);
		}
		
		//TODO: implement start() / stop();
		override public function onComplete(_id:String, onComplete:Function):void{
			//get the relevant dataObj by id
			var data:DataObj = this._calls.getElemByID(_id);
			//store the onComplete function for this id
			data.onComplete = onComplete;
			//add the event listener to this id
			this.loader.get(_id).addEventListener(data.eventComplete,onComplete,false,0,true);
		}
		
		override public function onAllComplete(_onAllComplete:Function):void{
			this._onAllCompleteFunction = _onAllComplete;
			this.loader.addEventListener(BulkProgressEvent.COMPLETE,_onAllComplete,false,0,true);
		}
		
		override public function getData(_id:String):DataObj{
			//get the callObj back to have the params to remove the Listener, added at this.onComplete()
			var data:DataObj = this._calls.getElemByID(_id);
			
			if(data == null){
				return new DataObj();
			}
			
			if(data.eventComplete != null && data.onComplete != null)
				this.loader.get(_id).removeEventListener(data.eventComplete,data.onComplete);
			//remove the dataObj from _calls
			this._calls.removeByID(_id);
		
			try{
				//TODO: the real result should be = data, and already should have the property .data
				var result:Object = (JSON.decode(this.loader.getText(_id,true)));
				
				var status:StatusObj = new StatusObj();
				status.Code = int(result.Status);
				if(result.Message == undefined)
					status.Message = "";
				else
					status.Message = String(result.Message);
				
				data.ResultData = JSON.decode(result.ResultData);
				data.Status = status;
					
			}catch(e:JSONParseError){
				throw new CustomError("JSON.decode was unsuccesfull for the dataSrouce call: " + data.toString() + "\n"
				+ " at location: " + e.location + " error msg: " +  e.message  + "\n" + e.text);
			}
			
			//clear up after all has been loaded
			if(this._calls.length == 0){ //all getData has been called for all IDs
				if(data.eventComplete != null && this._onAllCompleteFunction != null){
					this.loader.removeEventListener(BulkProgressEvent.COMPLETE,this._onAllCompleteFunction);
				}
				this._onAllCompleteFunction = null;
				this.loader.removeAll();
				this.loader.clear();
			}
			return data;
		}
	}
}