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
}
export const Util = new _Util()