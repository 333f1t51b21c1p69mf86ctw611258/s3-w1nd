import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs/Rx';
import { JhiDateUtils } from 'ng-jhipster';

import { Workflow } from './workflow.model';
import { ResponseWrapper, createRequestOption } from '../../shared';

@Injectable()
export class WorkflowService {

    private resourceUrl = 'api/workflows';

    constructor(private http: Http, private dateUtils: JhiDateUtils) { }

    create(workflow: Workflow): Observable<Workflow> {
        const copy = this.convert(workflow);
        return this.http.post(this.resourceUrl, copy).map((res: Response) => {
            const jsonResponse = res.json();
            this.convertItemFromServer(jsonResponse);
            return jsonResponse;
        });
    }

    update(workflow: Workflow): Observable<Workflow> {
        const copy = this.convert(workflow);
        return this.http.put(this.resourceUrl, copy).map((res: Response) => {
            const jsonResponse = res.json();
            this.convertItemFromServer(jsonResponse);
            return jsonResponse;
        });
    }

    find(id: number): Observable<Workflow> {
        return this.http.get(`${this.resourceUrl}/${id}`).map((res: Response) => {
            const jsonResponse = res.json();
            this.convertItemFromServer(jsonResponse);
            return jsonResponse;
        });
    }

    query(req?: any): Observable<ResponseWrapper> {
        const options = createRequestOption(req);
        return this.http.get(this.resourceUrl, options)
            .map((res: Response) => this.convertResponse(res));
    }

    delete(id: number): Observable<Response> {
        return this.http.delete(`${this.resourceUrl}/${id}`);
    }

    private convertResponse(res: Response): ResponseWrapper {
        const jsonResponse = res.json();
        for (let i = 0; i < jsonResponse.length; i++) {
            this.convertItemFromServer(jsonResponse[i]);
        }
        return new ResponseWrapper(res.headers, jsonResponse, res.status);
    }

    private convertItemFromServer(entity: any) {
        entity.createdDate = this.dateUtils
            .convertLocalDateFromServer(entity.createdDate);
        entity.lastModifiedDate = this.dateUtils
            .convertLocalDateFromServer(entity.lastModifiedDate);
    }

    private convert(workflow: Workflow): Workflow {
        const copy: Workflow = Object.assign({}, workflow);
        copy.createdDate = this.dateUtils
            .convertLocalDateToServer(workflow.createdDate);
        copy.lastModifiedDate = this.dateUtils
            .convertLocalDateToServer(workflow.lastModifiedDate);
        return copy;
    }
}
