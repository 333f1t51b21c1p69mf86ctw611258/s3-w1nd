import {Injectable} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {Http, Headers, Response, Request, RequestMethod, URLSearchParams, RequestOptions} from '@angular/http';
import {Observable} from 'rxjs/Rx';
declare var $: any;

@Injectable()
export class HttpClientService {

    requestUrl: string;
    responseData: any;
    handleError: any;

    constructor(private router: Router,
                private http: Http) {
        this.http = http;
    }

    postWithFile(url: string, postData: any, files: File[]) {

        const objHeaders = new Headers();
        const formData: FormData = new FormData();
        formData.append('file', files[0], files[0].name);
        // For multiple files
        // for (let i = 0; i < files.length; i++) {
        //     formData.append(`files[]`, files[i], files[i].name);
        // }

        if (postData !== '' && postData !== undefined && postData !== null) {
            for (const property in postData) {
                if (postData.hasOwnProperty(property)) {
                    formData.append(property, postData[property]);
                }
            }
        }

        const returnReponse = new Promise((resolve, reject) => {
            this.http.post(url, formData, {
                headers: objHeaders
            }).subscribe(
                (res) => {
                    this.responseData = res.json();
                    resolve(this.responseData);
                },
                (error) => {
                    this.router.navigate(['/login']);
                    reject(error);
                }
            );
        });
        return returnReponse;
    }

}
