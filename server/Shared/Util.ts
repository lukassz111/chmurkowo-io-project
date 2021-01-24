import { HttpRequest } from '../node_modules/@azure/functions'
import * as crypto from 'crypto'
class _Util {
    public hash(data: string|Buffer): string {
        return crypto.createHash('md5').update(data).digest('hex')
    }
    public getCurrentTimestamp(): number {
        return Math.floor(Date.now() / 1000)
    }
    public secondsToMinutes(v: number): number {
        return Math.floor(v/60)
    }
    public getBaseUrl(req: HttpRequest): string {
        let regex = /^(?:http(?:s?):\/\/[\w\.\:\d]{1,}\/)/
        let baseUrl = regex.exec(req.url)[0];
        return baseUrl;
    }
    public isProduction(req: HttpRequest): boolean {
        let base = this.getBaseUrl(req);
        return (base == "https://chmurkowo.azurewebsites.net/");
    }
}
export const Util = new _Util()