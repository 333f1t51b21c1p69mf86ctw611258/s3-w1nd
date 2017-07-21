import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs/Rx';
import { JhiDateUtils } from 'ng-jhipster';

import { WorkflowStep } from './workflow-step.model';
import { ResponseWrapper, createRequestOption } from '../../shared';

@Injectable()
export class WorkflowStepService {

    private resourceUrl = 'api/workflow-steps';
    private resourceUrl_ByWorkflowId = 'api/workflow-steps-by-workflow-id';
    private resourceUrl_CountByWorkflowId = 'api/workflow-step-count-by-workflow-id';

    private resourceUrl_InitByStepName = 'api/init-workflow-step-by-step-name';

    constructor(private http: Http, private dateUtils: JhiDateUtils) { }

    create(workflowStep: WorkflowStep): Observable<WorkflowStep> {
        const copy = this.convert(workflowStep);
        return this.http.post(this.resourceUrl, copy).map((res: Response) => {
            const jsonResponse = res.json();
            this.convertItemFromServer(jsonResponse);
            return jsonResponse;
        });
    }

    update(workflowStep: WorkflowStep): Observable<WorkflowStep> {
        const copy = this.convert(workflowStep);
        return this.http.put(this.resourceUrl, copy).map((res: Response) => {
            const jsonResponse = res.json();
            this.convertItemFromServer(jsonResponse);
            return jsonResponse;
        });
    }

    find(id: number): Observable<WorkflowStep> {
        return this.http.get(`${this.resourceUrl}/${id}`).map((res: Response) => {
            const jsonResponse = res.json();
            this.convertItemFromServer(jsonResponse);
            return jsonResponse;
        });
    }

    initByStepName(stepName: string): Observable<WorkflowStep> {
        return this.http.get(`${this.resourceUrl_InitByStepName}/${stepName}`).map((res: Response) => {
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

    queryByWorkflowId(workflowId: number, req?: any): Observable<ResponseWrapper> {
        const options = createRequestOption(req);
        return this.http.get(`${this.resourceUrl_ByWorkflowId}/${workflowId}`, options)
            .map((res: Response) => this.convertResponse(res));
    }

    queryCountByWorkflowId(workflowId: number): Observable<ResponseWrapper> {
        return this.http.get(`${this.resourceUrl_CountByWorkflowId}/${workflowId}`)
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

    private convert(workflowStep: WorkflowStep): WorkflowStep {
        const copy: WorkflowStep = Object.assign({}, workflowStep);
        copy.createdDate = this.dateUtils
            .convertLocalDateToServer(workflowStep.createdDate);
        copy.lastModifiedDate = this.dateUtils
            .convertLocalDateToServer(workflowStep.lastModifiedDate);
        return copy;
    }
}
