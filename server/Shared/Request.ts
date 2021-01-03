import { HttpRequest } from "@azure/functions"
import * as qs from 'querystringify'

export function getParam<T>(request: HttpRequest,paramName: string, defaultValue: T): T {
    if(request.body == undefined) {
        return defaultValue
    }
    let body = request.body
    let objBody = qs.parse(unescape(body))
    console.log(objBody);
    let value = objBody[paramName]
    console.log("p "+paramName +" = "+value)
    if(value == undefined || value == null) {
        return defaultValue
    } 
    return value
}

export function getParamNullable<T>(request: HttpRequest, paramName: string): (T | null) {
    return getParam<T|null>(request,paramName,null)
}