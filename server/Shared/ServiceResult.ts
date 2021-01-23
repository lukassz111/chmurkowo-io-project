export interface ServiceResult<T> {
    result: boolean,
    value?: T,
    errorCode?: number,
    info: string
}