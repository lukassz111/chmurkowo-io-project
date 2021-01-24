import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { PinService } from "../Shared/PinService";
import { ResponseCreator } from "../Shared/Response";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let pins = await PinService.get(context,req).getAllPins()
    if(pins == null) {
        ResponseCreator.createsErrorResponse({},'no pins').setResponse(context)
        return
    }

    let pinsData = JSON.stringify(pins)
    ResponseCreator.createsSuccessResponse({
        pinsData
    }).setResponse(context)
};

export default httpTrigger;