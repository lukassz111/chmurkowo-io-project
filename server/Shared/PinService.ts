import { EntityManager } from "typeorm"
import { Pin } from "../typeorm/entity/Pin"
import { User } from "../typeorm/entity/User"
import { DatabaseConnection } from "./DatabaseConnection"
import { ImageService } from "./ImageService"
import { ServiceResult } from "./ServiceResult"
import { Util } from './Util'
import { Context, HttpRequest } from "../node_modules/@azure/functions"
import { CognitiveService } from "./CognitiveService"
import { ErrorCodes } from "./ErrorCodes"
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
    public async addPin(user: User, lat: string, long: string, base64dataOfImage: string,skipCognitiveService: boolean = false): Promise<ServiceResult<number>> {
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
                info: "too small offset",
                errorCode: ErrorCodes.AddPinTooSmallOffset
            }
        }

        let imageService = ImageService.get(this.context,this.req);
        await imageService.save(base64dataOfImage,filename)
        //imageUrl musi byc URLem do naszego zdjecia
        let imageUrl = imageService.getUrl(filename);
        console.log(imageUrl);
        
        if(!skipCognitiveService) {
            let isACloud = CognitiveService.recognizeImageAsCloud(imageUrl);
            console.log(`isACloud: ${isACloud}`);
            if(!isACloud){
                return {
                    result: false,
                    info: "not a cloud",
                    errorCode: ErrorCodes.AddPinImageDoNotRepresentCloud
                }
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
            info: "ok",
            errorCode: ErrorCodes.Ok
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

    public async getAllPins(): Promise<Pin[]|null>{
        await DatabaseConnection.initialize()
        let pinRepo = await DatabaseConnection.Connection.getRepository(Pin)
        let pins = pinRepo.find({loadRelationIds: true})
        if((await pins).length && (await pins).length > 0) {
            console.log(pins)
            return pins
        }
        return null
    }

    //lat1, long1 połnocno zachodni
    //lat2, long2 połodniowo wschodni
    public async getAllPinsInArea(lat1: number,long1: number, lat2: number, long2: number): Promise<Pin[]|null>{
        await DatabaseConnection.initialize()
        let pinRepo = await DatabaseConnection.Connection.getRepository(Pin)
        //TODO gdzieś tutaj filtrowanie 
        let pins = pinRepo.find({loadRelationIds: true})
        if((await pins).length && (await pins).length > 0) {
            return pins
        }
        return null
    }
}
export { PinService }