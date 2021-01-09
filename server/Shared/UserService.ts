import { User } from "../typeorm/entity/User";
import { DatabaseConnection } from "./DatabaseConnection";

class _UserService {
    public async getUserByGoogleId(googleId: string): Promise<User|null> {
        let users = await DatabaseConnection.Connection.getRepository(User).createQueryBuilder().select().where("id = '"+googleId+"'").getMany()
        if(users.length > 0) {
            return users[0]
        }
        return null
    }
} 
export const UserService = new _UserService()