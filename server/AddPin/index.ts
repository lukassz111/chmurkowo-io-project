import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { ResponseCreator } from "../Shared/Response";
import { UserService } from "../Shared/UserService";
import { PinService } from "../Shared/PinService";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let contentType = req.headers['content-type']
    if(contentType == null || contentType == undefined) {
        ResponseCreator.createsErrorResponse().setResponse(context)
        return
    }
    let regexBoundary = /(?:boundary=)([^\s]{1,})/
    let regexNameOfPart = /(?:(?:content-disposition:\sform-data;\sname=")(.{1,})(?:"\s?))/
    let boundary: string = "--"+regexBoundary.exec(contentType)[1]
    let buffer = req.body as Buffer
    let bufferString = buffer.toString()
    let dataRaw = bufferString.split(boundary)
    dataRaw.splice(0,1)
    dataRaw.splice(dataRaw.length-1,1)
    let data = {}
    dataRaw.forEach((d)=>{
        let name = regexNameOfPart.exec(d)[1]
        let regexDataOfPart = new RegExp('(?:name="'+name+'"{1,}\\s)([^]{1,})')
        let stringData =regexDataOfPart.exec(d)[1].trim()
        data[name] = stringData
    })
    let position_lat: string = data['position_lat']
    let position_long: string = data['position_long']
    let googleId: string = data['id']
    let file: string = data['file']
    if(file == undefined || file == null || googleId == null || googleId == undefined || position_lat == undefined || position_lat == null || position_long == null || position_long == undefined) {
        ResponseCreator.createsErrorResponse().setResponse(context)
        return
    }

    let user = await UserService.getUserByGoogleId(googleId)
    if(user == null) {
        ResponseCreator.createsErrorResponse({},"user do not exist").setResponse(context)
        return
    }
    let result = await PinService.addPin(user,position_lat,position_long,file)
    console.log(result)
    if( result.result ) {
        ResponseCreator.createsSuccessResponse({"pinId": result.value }).setResponse(context)
    } else {
        ResponseCreator.createsErrorResponse({},"cannot add pin: "+result.info).setResponse(context)
    }
};

export default httpTrigger;