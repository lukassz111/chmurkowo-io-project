import { User } from "../typeorm/entity/User";
import { DatabaseConnection } from "./DatabaseConnection";

class _UserService {
    public async getUserByGoogleId(googleId: string): Promise<User|null> {
        await DatabaseConnection.initialize()
        //console.log(await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("googleId = '"+googleId+"'").getQuery())
        let users = await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("googleId = '"+googleId+"'").getMany()
        if(users.length > 0) {
            return users[0]
        }
        return null
    }

    public async getUserById(id: string): Promise<User|null> {
        await DatabaseConnection.initialize()
        //console.log(await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("googleId = '"+googleId+"'").getQuery())
        let users = await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("id = '"+id+"'").getMany()
        if(users.length > 0) {
            return users[0]
        }
        return null
    }
} 
export const UserService = new _UserService()