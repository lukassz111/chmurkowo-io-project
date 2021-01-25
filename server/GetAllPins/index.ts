import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import request = require("request");
import { PinService } from "../Shared/PinService";
import { getParamNullable } from "../Shared/Request";
import { ResponseCreator } from "../Shared/Response";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let lat1 = getParamNullable<number>(req,'lat1');
    let long1 = getParamNullable<number>(req,'long1');
    let lat2 = getParamNullable<number>(req,'lat2');
    let long2 = getParamNullable<number>(req,'long2');

    let pins: any = null;

    //Argument są pobierane z body a jak nie ma ich tam to z url'a ?lat1=124124 itd
    if(lat1 == null || lat2 == null || long1 == null || long2 == null) {
        pins = await PinService.get(context,req).getAllPins()//Brakuje argumentu to wywal wszystko
    } else {
        pins = await PinService.get(context,req).getAllPinsInArea(lat1,long1,lat2,long2)//Argumenty są to z filtrowaniem
    }

    if(pins == null) {
        ResponseCreator.createsSuccessResponse({"pinsData":[]}).setResponse(context)
        return
    }

    let pinsData = pins
    ResponseCreator.createsSuccessResponse({
        pinsData
    }).setResponse(context)
};

export default httpTrigger;