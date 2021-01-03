import { ConnectionConfig } from "mysql";
import { ConnectionOptions } from "typeorm";
import { User } from "../typeorm/entity/User";

const DbConfig: ConnectionOptions = {
    type: "mysql",
    host: "chmurkowo.mysql.database.azure.com",
    username: "login",
    password: "$9e3f167d14940977488faf865048eb15",
    database: "chmurkowo",
    port: 3306,
    ssl: true,
    entities: [
        User
    ]
}
export { DbConfig };

    