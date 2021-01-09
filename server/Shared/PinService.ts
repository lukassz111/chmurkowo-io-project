import { Pin } from "../typeorm/entity/Pin"
import { User } from "../typeorm/entity/User"
import { DatabaseConnection } from "./DatabaseConnection"
import { ImageService } from "./ImageService"
import { ServiceResult } from "./ServiceResult"
import { Util } from './Util'
class _PinService {
    public async addPin(user: User, lat: string, long: string, base64dataOfImage: string): Promise<ServiceResult> {
        let id = user.id.toString()
        let hashLat = Util.hash(lat.toString())
        let hashLong = Util.hash(long.toString())
        let hashPosition = Util.hash(hashLat+hashLong)
        let hashImage = Util.hash(base64dataOfImage)
        let filename = 'img_'+id.toString()+"_"+Util.hash(hashImage+hashPosition)

        if(user.premium) {
            //TODO for premium users
        }

        let currentTimestamp = Util.getCurrentTimestamp()
        let offset = Util.secondsToMinutes(currentTimestamp - user.lastPhotoTimestamp)
        if(offset < 30 ) {
            return {
                result: false,
                info: "too small offset"
            }
        }
        user.lastPhotoTimestamp = currentTimestamp
        user.resetPhotosLeft()


        let pin = new Pin()
        pin.setDefault(parseFloat(lat),parseFloat(long),ImageService.formatPath(filename),user)
        await DatabaseConnection.Connection.getRepository(Pin).save(pin)
        await DatabaseConnection.Connection.getRepository(User).save(user)

        ImageService.save(base64dataOfImage,filename)
        return {
            result: true,
            info: "ok"
        } 
    }
}
export const PinService = new _PinService()