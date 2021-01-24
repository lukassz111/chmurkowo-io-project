import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { PinService } from "../Shared/PinService";
import { getParam, getParamNullable } from "../Shared/Request";
import {ImageService} from "../Shared/ImageService"
import { ResponseCreator } from "../Shared/Response";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let pinId = getParamNullable<number>(req,'pinId')
    //context.log(req)
    if(pinId == null) {
        ResponseCreator.createsErrorResponse({},'reqiure pinId param').setResponse(context)
        return
    } 
    let pin = await PinService.get(context,req).getPinById(pinId)
    if(pin == null) {
        ResponseCreator.createsErrorResponse({},'pin not exist').setResponse(context)
        return
    }

    ResponseCreator.createsSuccessResponse({
        "photoName":pin.photo_filename
    }).setResponse(context)
};

export default httpTrigger;