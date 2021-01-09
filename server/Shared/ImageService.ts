import * as fs from 'fs'

class _ImageService {
    private get BaseDir(): string {
        return './data/'
    }
    private get FileExtension(): string {
        return '.png'
    }
    private formatPath(filename): string {
        let p = this.BaseDir + filename + this.FileExtension
        return p
    }

    public save(base64data: string, filename: string) {
        fs.writeFileSync(this.formatPath(filename),base64data,'base64')
        /*
        fs.writeFile(this.formatPath(filename),base64data,'base64',(err)=>{
            if(err != null && err != undefined) {
                console.error(err)
            }
        })
        */
    }
}
export const ImageService = new _ImageService();