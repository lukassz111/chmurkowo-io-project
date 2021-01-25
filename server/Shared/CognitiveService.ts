import * as request from 'request';
import 'axios';
import axios, { AxiosResponse } from 'axios';

interface CognitiveServiceCategory {
    name: string,
    score: number
}
interface CognitiveServiceResponse {
    imageUrl: string,
    categories: Array<CognitiveServiceCategory>
}
class _CognitiveService {

    private get cognitiveServicesParams() {
        return {
            'visualFeatures': 'Categories,Description,Color,Nature',
            'details': '',
            'language': 'en'
        }
    }
    private get subscriptionKey(): string {
        return '9cda7dce2f7c4f679fec791b5d6264e8';
    }
    private get uriBase(): string {
        let endpoint = "https://monisaagatka1.cognitiveservices.azure.com/";
        return endpoint + 'vision/v3.1/analyze';
    }
    private options(imageUrl: string) {
        return {
            uri: this.uriBase,
            qs: this.cognitiveServicesParams,
            body: '{"url": ' + '"' + imageUrl + '"}',
            headers: {
                'Content-Type': 'application/json',
                'Ocp-Apim-Subscription-Key' : this.subscriptionKey
            }
        }
    }

    public async recognizeImageRaw(imageUrl: string): Promise<CognitiveServiceResponse> {
        let json = JSON.stringify({"url":imageUrl});
        return axios.post(this.uriBase,json,{
            headers: { 
                'Content-Type': 'application/json',
                'Ocp-Apim-Subscription-Key' : this.subscriptionKey
            },
        })
        .then((response)=>{
            let categories = response.data.categories;
            let r: CognitiveServiceResponse = {
                imageUrl:imageUrl,
                categories:categories
            };
            console.log(JSON.stringify(r));
            return r;
        },(reason)=>{
            console.warn(JSON.stringify(reason));
            let r: CognitiveServiceResponse = {
                imageUrl:imageUrl,
                categories: []
            }
            console.log(JSON.stringify(r));
            return r;
        })
    }
    public async recognizeImageAsCloud(imageUrl: string): Promise<boolean> {
        let r = await this.recognizeImageRaw(imageUrl)
        let categories: Array<String> = []
        r.categories.forEach((c)=>{
            if(c.score > 0.25) {
                categories.push(c.name)
            }
        })
        let categoriesToCheck: Array<string> = ['sky_cloud','cloud'];
        for(let i = 0; i < categoriesToCheck.length; i++) {
            let categoryToCheck = categoriesToCheck[i]
            if(categories.includes(categoryToCheck)) {
                return true
            }
        }
        return false
    }
}

export const CognitiveService = new _CognitiveService();