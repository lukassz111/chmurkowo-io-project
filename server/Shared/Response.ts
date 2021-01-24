import { Context } from "../node_modules/@azure/functions";
import { ErrorCodes } from "./ErrorCodes";
import { ServiceResult } from "./ServiceResult";
export interface ResponseMeta {
    success: boolean,
    info?: string,
    info_request_body?: string,
    error_code: number,
}
export interface Response {
    data: any,
    meta: ResponseMeta,
}
export class ResponseCreator {
    public static createsSuccessResponse(data: any = {}) {
        let responseCreator = new ResponseCreator()
        responseCreator.responseData = {
            data: data,
            meta: {
                success: true,
                error_code: ErrorCodes.Ok
            }
        }
        return responseCreator;
    }
    public static createsErrorResponse(data: any = {},info: string|null = null) {
        let responseCreator = new ResponseCreator()
        responseCreator.responseData = {
            data: data,
            meta: {
                success: false,
                error_code: ErrorCodes.SomethingGetsWrong
            }
        }
        if(info != null) {
            responseCreator.responseData.meta.info = info
        }
        return responseCreator; 
    }
    public static createErrorResponseService<T>(data: any = {}, serviceResult: ServiceResult<T>) {
        let responseCreator = new ResponseCreator()
        responseCreator.responseData = {
            data: data,
            meta: {
                success: false,
                error_code: ErrorCodes.SomethingGetsWrong
            }
        }
        if(serviceResult.info != null) {
            responseCreator.responseData.meta.info = serviceResult.info;
        }
        if(serviceResult.errorCode != null) {
            responseCreator.responseData.meta.error_code = serviceResult.errorCode;
        }
        return responseCreator; 
    }
    public status: number = 200;
    public responseData: Response = {
        data: {},
        meta: {
            success: true,
            error_code: ErrorCodes.Ok
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