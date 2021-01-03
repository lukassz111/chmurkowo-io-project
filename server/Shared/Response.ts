import { Context } from "@azure/functions";
export interface ResponseMeta {
    success: boolean,
    info?: string
}
export interface Response {
    data: any,
    meta: ResponseMeta
}
export class ResponseCreator {
    public static createsSuccessResponse(data: any = {}) {
        let responseCreator = new ResponseCreator()
        responseCreator.responseData = {
            data: {},
            meta: {
                success: true
            }
        }
        return responseCreator;
    }
    public static createsErrorResponse(data: any = {},info: string|null = null) {
        let responseCreator = new ResponseCreator()
        responseCreator.responseData = {
            data: {},
            meta: {
                success: false
            }
        }
        if(info != null) {
            responseCreator.responseData.meta.info = info
        }
        return responseCreator;
    }
    public status: number = 200;
    public responseData: Response = {
        data: {},
        meta: {
            success: true
        }
    }
    public setResponse(context: Context) {

        context.res = {
            body: JSON.stringify(this.responseData),
            headers: {
                'Content-Type':'application/json'
            },
            status: this.status
        }
    }
}