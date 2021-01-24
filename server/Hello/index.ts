import { AzureFunction, Context, HttpRequest } from "../node_modules/@azure/functions"
import { DatabaseConnection } from "../Shared/DatabaseConnection";
import { ResponseCreator } from "../Shared/Response"
import * as Request from '../Shared/Request'
import { User } from "../typeorm/entity/User";
import { UserService } from "../Shared/UserService";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    const googleId = Request.getParamNullable<string>(req,'googleId')
    const email = Request.getParamNullable<string>(req,'email')
    console.log("Hello: "+email)
    const displayName = Request.getParamNullable<string>(req,'displayName')
    await DatabaseConnection.initialize();
    if(googleId == null && displayName == null && email == null) {
        let responseCreator = ResponseCreator.createsErrorResponse({},'required')
        responseCreator.responseData.meta.info_request_body = JSON.stringify("googleId: "+googleId+" displayName: "+displayName+" email: "+email)
        responseCreator.setResponse(context)
        return
    }
    
    let x = await UserService.getUserByGoogleId(googleId)
    if(x == null) {
        let user = new User()
        user.setDefault(googleId,displayName,email)
        await DatabaseConnection.Connection.getRepository(User).save(user)
        ResponseCreator.createsSuccessResponse().setResponse(context)
        return
    }
    else if(x.googleId == googleId && x.email == email) {
        ResponseCreator.createsSuccessResponse().setResponse(context)
        return
    }
    ResponseCreator.createsErrorResponse({},'any_other').setResponse(context)
    return
};

export default httpTrigger;