export interface ServiceResult<T> {
    result: boolean,
    value?: T,
    info: string
}