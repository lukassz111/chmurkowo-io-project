class _CognitiveService {

    public recognizeImage(imageUrl: string) {
        const request = require('request');

        //let subscriptionKey = process.env['9cda7dce2f7c4f679fec791b5d6264e8'];
        let subscriptionKey = '9cda7dce2f7c4f679fec791b5d6264e8';
        let endpoint = process.env['https://monisaagatka1.cognitiveservices.azure.com/']
        if (!subscriptionKey) { throw new Error('Set your environment variables for your subscription key and endpoint.'); }

        var uriBase = endpoint + 'vision/v3.1/analyze';


// Request parameters.
        const params = {
            'visualFeatures': 'Categories,Description,Color,Nature',
            'details': '',
            'language': 'en'
        };

        const options = {
            uri: uriBase,
            qs: params,
            body: '{"url": ' + '"' + imageUrl + '"}',
            headers: {
                'Content-Type': 'application/json',
                'Ocp-Apim-Subscription-Key' : subscriptionKey
            }
        };

        request.post(options, (error, response, body) => {
            if (error) {
                console.log('Error: ', error);
                return;
            }
            let jsonResponse = JSON.stringify(JSON.parse(body), null, '  ');
            console.log('JSON Response\n');
            console.log(jsonResponse);
            if(body.categories.name.includes("cloud"))
            {
                if(body.categories.score > 0.5)
                {
                    return true;
                }
            }
        });
        return false;
    }
}

export const CognitiveService = new _CognitiveService();