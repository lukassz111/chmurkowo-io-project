import { AzureFunction, Context, HttpRequest } from "@azure/functions"

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    let responseMessage: string = JSON.stringify(req.body )
    let responseMessagex = responseMessage.substr(0,100) + "......" + responseMessage.substr(responseMessage.length-101,100);
    let x = 5000;
    console.log(responseMessage.substr(0,x))
    console.log(responseMessage.substr(responseMessage.length-(x+1),x))
    let d = req;
    d.body = ""
    console.log(JSON.stringify(d));
    responseMessage = JSON.stringify(responseMessage)
   
    context.res = {
        // status: 200, /* Defaults to 200 */
        body: responseMessagex
    };

};

export default httpTrigger;