
import { type } from 'os';
import * as typeorm from 'typeorm'
import { DbConfig } from './DbConfig';

class _DatabaseConnection {
    private _initialized = false;
    private _connection: typeorm.Connection = null;
    public async initialize() {
        if(this._initialized) {
            this._connection = typeorm.getConnection()
            return;
        }
        this._connection = await typeorm.createConnection(DbConfig)
        this._initialized = true
    }
    public get isInitialized(): Boolean {
        return this._initialized
    }
    public get Connection(): typeorm.Connection {
        return this._connection
    }
}
export const DatabaseConnection = new _DatabaseConnection();