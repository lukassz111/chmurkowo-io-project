import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { DatabaseConnection } from "../Shared/DatabaseConnection";
import { ResponseCreator } from "../Shared/Response"
import * as Request from '../Shared/Request'
import { User } from "../typeorm/entity/User";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    const googleId = Request.getParamNullable<string>(req,'googleId')
    const email = Request.getParamNullable<string>(req,'email')
    const displayName = Request.getParamNullable<string>(req,'displayName')
    await DatabaseConnection.initialize();
    if(googleId == null && displayName == null && email == null) {
        let responseCreator = ResponseCreator.createsErrorResponse({},'required')
        responseCreator.responseData.meta.info_request_body = JSON.stringify("googleId: "+googleId+" displayName: "+displayName+" email: "+email)
        responseCreator.setResponse(context)
        return
    }
    
    let x = await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("id = '"+googleId+"'").getMany()
    if(x.length < 1) {
        let user = new User()
        user.displayName = displayName 
        user.googleId = googleId
        user.email = email
        user.score = 0
        user.premium = false;
        await DatabaseConnection.Connection.getRepository(User).save(user)
        ResponseCreator.createsSuccessResponse().setResponse(context)
        return
    }
    else if(x[0].googleId == googleId && x[0].email == email) {
        ResponseCreator.createsSuccessResponse().setResponse(context)
        return
    }
    ResponseCreator.createsErrorResponse({},'any_other').setResponse(context)
    return
};

export default httpTrigger;