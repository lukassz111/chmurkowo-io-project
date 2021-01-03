import { HttpRequest } from "@azure/functions"

export function getParam<T>(request: HttpRequest,paramName: string, defaultValue: T): T {
    if(request.body == undefined) {
        return defaultValue
    }
    let body = request.body 
    let value = body[paramName]
    if(value == undefined || value == null) {
        return defaultValue
    } 
    return value
}

export function getParamNullable<T>(request: HttpRequest, paramName: string): (T | null) {
    return getParam<T|null>(request,paramName,null)
}