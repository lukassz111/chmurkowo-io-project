import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { ResponseCreator } from "../Shared/Response";
import * as fs from 'fs'
import * as crypto from 'crypto'

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    console.log("req")
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
    let hash = (data: string|Buffer): string => {
        return crypto.createHash('md5').update(data).digest('hex')
    } 
    let hashGoogleId = hash(googleId.toString())
    let hashLat = hash(position_lat.toString())
    let hashLong = hash(position_long.toString())
    let hashPosition = hash(hashLat+hashLong)
    let hashImage = hash(buffer)
    let filename = 'img_'+hash(hashGoogleId+hashImage+hashPosition)+'.png'
    console.log(filename)
    fs.writeFile(filename,file,'base64',(err)=>{
        if(err != null && err != undefined) {
            console.error(err)
        }
    })
    
    context.res = {
        // status: 200, /* Defaults to 200 */
        body: "x"
    };

};

export default httpTrigger;