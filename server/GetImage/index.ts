import { AzureFunction, Context, HttpRequest } from '@azure/functions'
import { ImageService } from '../Shared/ImageService';

const fs = require('fs');
const util = require('util');
const readFileAsync = util.promisify(fs.readFile);
const fileExistsAsync = util.promisify(fs.exists);

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {

    const baseDir = ImageService.get(context,req).BaseDir;
    if(!Object.prototype.hasOwnProperty.call(req.query,'i')) {
        context.res = { status: 404 };
        return;
    }
    let path = req.query.i;

    const fileMap = {
        fileName: `${baseDir}/${path}`,
        contentType: 'image/png'
    };

    console.log(fileMap);

    if (await fileExistsAsync(fileMap.fileName)) {

        context.res = {
            body: await readFileAsync(fileMap.fileName),
            headers: { 'Content-Type': fileMap.contentType }
        };

    } else {

        context.res = { status: 404 };
    }

};

export default httpTrigger;