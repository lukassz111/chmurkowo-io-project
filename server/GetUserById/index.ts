import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { print } from "util";
import { getParamNullable } from "../Shared/Request";
import { ResponseCreator } from "../Shared/Response";
import { UserService } from "../Shared/UserService";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let id = getParamNullable<string>(req,'id')
    if(id == null) {
        ResponseCreator.createsErrorResponse({},'no id in request').setResponse(context)
        return
    }
    let user = await UserService.getUserById(id)
    console.log(user)
    if(user == null){
        ResponseCreator.createsErrorResponse({},"user doesn't exist").setResponse(context)
        return
    }
    else ResponseCreator.createsSuccessResponse({
        "user":user
     }).setResponse(context)
};

export default httpTrigger;