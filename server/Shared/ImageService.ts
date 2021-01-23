import * as fs from 'fs';
import { Context, HttpRequest } from "@azure/functions"
class ImageService {
    private static _instance: ImageService = null;
    public static get(context: Context, req: HttpRequest) {
        if(ImageService._instance == null) {
            ImageService._instance = new ImageService(context,req);
        }
        return ImageService._instance;
    }
    private context: Context;
    private req: HttpRequest;
    private constructor(context: Context, req: HttpRequest) {
        this.context = context;
        this.req = req;

        if(!fs.existsSync(this.BaseDir))
            fs.mkdirSync(this.BaseDir)
    }
    private get BaseDir(): string {
        return 'C:\\home\\site\\wwwroot\\data\\'
    }
    private get FileExtension(): string {
        return '.png'
    }
    public formatPath(filename): string {
        let p = this.BaseDir + filename + this.FileExtension
        return p
    }

    public async save(base64data: string, filename: string) {
        fs.writeFileSync(this.formatPath(filename),base64data,'base64')
    }

    public getUrl(filename: string) {
        let regex = /^(?:http(?:s?):\/\/[\w\.\:\d]{1,}\/)/
        let baseUrl = regex.exec(this.req.url)[0];
        let url = baseUrl + "api/GetImage?i="+filename+".png";
        return url;
    }
}
export { ImageService }