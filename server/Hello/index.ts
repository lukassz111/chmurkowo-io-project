import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { DatabaseConnection } from "../Shared/DatabaseConnection";
import { ResponseCreator } from "../Shared/Response"
import * as Request from '../Shared/Request'
import { User } from "../typeorm/entity/User";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    const id = Request.getParamNullable<string>(req,'id')
    const displayName = Request.getParamNullable<string>(req,'displayName')
    await DatabaseConnection.initialize();
    if(id == null && displayName == null) {
        let responseCreator = ResponseCreator.createsErrorResponse({},'required')
        responseCreator.responseData.meta.info_request_body = JSON.stringify("id: "+id+" displayName: "+displayName)
        responseCreator.setResponse(context)
        return
    }
    
    console.log(DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("id = '"+id+"'").getQuery()) 
    let x = await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("id = '"+id+"'").getMany()
    if(x.length < 1) {
        let user = new User()
        user.displayName = displayName 
        user.id = id
        await DatabaseConnection.Connection.getRepository(User).save(user)
        ResponseCreator.createsSuccessResponse().setResponse(context)
        return
    }
    else if(x[0].id == id && x[0].displayName == displayName) {
        ResponseCreator.createsSuccessResponse().setResponse(context)
        return
    }
    ResponseCreator.createsErrorResponse({},'any_other').setResponse(context)
    return
};

export default httpTrigger;