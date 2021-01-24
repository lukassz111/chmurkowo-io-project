import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import { CognitiveService } from "../Shared/CognitiveService";
import { ImageService } from '../Shared/ImageService';
const fs = require('fs');
const util = require('util');
const readFileAsync = util.promisify(fs.readFile);
const fileExistsAsync = util.promisify(fs.exists);
const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    
    const imageService = ImageService.get(context,req);
    const baseDir = imageService.BaseDir;
    if(!Object.prototype.hasOwnProperty.call(req.query,'i')) {
        context.res = { status: 404 };
        return;
    }
    let path = req.query.i;

    const fileMap = {
        fileName: `${baseDir}/${path}`,
    };


    if (await fileExistsAsync(fileMap.fileName) || true) {
        let url = imageService.getUrl(path);
        //url = "https://chmurkowo.azurewebsites.net/api/GetImage?code=O9RnW7whjIhX4QIOyOcqshVWCnjMHLR0Vm7qsNONu/A9YEswgJuBXg==&i=img_4_2243d705044cc9e97fa97f8ee4c66862.png";
        context.res = {
            body: await CognitiveService.recognizeImageRaw(url),
            headers: { 'Content-Type': 'application/json' }
        };

    } else {

        context.res = { status: 404 };
    }
};

export default httpTrigger;