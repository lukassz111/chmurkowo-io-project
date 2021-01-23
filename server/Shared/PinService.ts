import { EntityManager } from "typeorm"
import { Pin } from "../typeorm/entity/Pin"
import { User } from "../typeorm/entity/User"
import { DatabaseConnection } from "./DatabaseConnection"
import { ImageService } from "./ImageService"
import { ServiceResult } from "./ServiceResult"
import { Util } from './Util'
import { Context, HttpRequest } from "@azure/functions"
import { CognitiveService } from "./CognitiveService"
class PinService {
    private static _instance: PinService = null;
    public static get(context: Context, req: HttpRequest) {
        if(PinService._instance == null) {
            PinService._instance = new PinService(context,req);
        }
        return PinService._instance;
    }
    private context: Context;
    private req: HttpRequest;
    private constructor(context: Context, req: HttpRequest) {
        this.context = context;
        this.req = req;
    }
    public async addPin(user: User, lat: string, long: string, base64dataOfImage: string): Promise<ServiceResult<number>> {
        let initDb = DatabaseConnection.initialize()
        let id = user.id.toString()
        let hashLat = Util.hash(lat.toString())
        let hashLong = Util.hash(long.toString())
        let hashPosition = Util.hash(hashLat+hashLong)
        let hashImage = Util.hash(base64dataOfImage)
        let filename = 'img_'+id.toString()+"_"+Util.hash(hashImage+hashPosition)

        let currentTimestamp = Util.getCurrentTimestamp()

        let offset = Util.secondsToMinutes(currentTimestamp - user.lastPhotoTimestamp)
        if(offset < 30 && user.premium == false ) {
            return {
                result: false,
                info: "too small offset"
            }
        }

        let imageService = ImageService.get(this.context,this.req);
        await imageService.save(base64dataOfImage,filename)
        //imageUrl musi byc URLem do naszego zdjecia
        let imageUrl = imageService.getUrl(filename);
        console.log(imageUrl);
        
        let isACloud = CognitiveService.recognizeImage(imageUrl);
        console.log(`isACloud: ${isACloud}`);
        if(!isACloud){
            return {
                result: false,
                info: "not a cloud"
            }
        }

        user.lastPhotoTimestamp = currentTimestamp
        user.resetPhotosLeft()
        console.log('OK, CAN ADD PIN')
        await initDb;
        let pin = new Pin()
        pin.setDefault(parseFloat(lat),parseFloat(long),filename,user)
        let insertedPin = await DatabaseConnection.Connection.getRepository(Pin).save(pin)
        await DatabaseConnection.Connection.getRepository(User).save(user)

        return {
            result: true,
            value: insertedPin.id,
            info: "ok"
        } 
    }

    public async getPinById(pinId: number): Promise<Pin|null> {
        await DatabaseConnection.initialize()
        let pins = await DatabaseConnection.Connection.getRepository(Pin).createQueryBuilder().select().where("id = "+pinId).getMany()
        if(pins.length > 0) {
            return pins[0]
        }
        return null
    }
}
export { PinService }