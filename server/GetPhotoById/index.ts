import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { PinService } from "../Shared/PinService";
import { getParam, getParamNullable } from "../Shared/Request";
import { ResponseCreator } from "../Shared/Response";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let pinId = getParamNullable<number>(req,'pinId')
    if(pinId == null) {
        ResponseCreator.createsErrorResponse({},'reqiure pinId param').setResponse(context)
        return
    } 
    let pin = await PinService.get(context,req).getPinById(pinId)
    if(pin == null) {
        ResponseCreator.createsErrorResponse({},'pin not exist').setResponse(context)
        return
    }
    console.log(pin.photo_filename)
    ResponseCreator.createsSuccessResponse({
        "filename":pin.photo_filename
    }).setResponse(context)
    console.log(context)
};

export default httpTrigger;