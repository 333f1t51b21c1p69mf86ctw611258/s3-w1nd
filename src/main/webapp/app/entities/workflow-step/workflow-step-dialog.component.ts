import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Response } from '@angular/http';

import { Observable } from 'rxjs/Rx';
import { NgbActiveModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { JhiEventManager, JhiAlertService } from 'ng-jhipster';

import { WorkflowStep } from './workflow-step.model';
import { WorkflowStepPopupService } from './workflow-step-popup.service';
import { WorkflowStepService } from './workflow-step.service';
import { Workflow, WorkflowService } from '../workflow';
import { ResponseWrapper } from '../../shared';

@Component({
    selector: 'jhi-workflow-step-dialog',
    templateUrl: './workflow-step-dialog.component.html'
})
export class WorkflowStepDialogComponent implements OnInit {

    workflowStep: WorkflowStep;
    authorities: any[];
    isSaving: boolean;

    workflows: Workflow[];
    createdDateDp: any;
    lastModifiedDateDp: any;

    constructor(
        public activeModal: NgbActiveModal,
        private alertService: JhiAlertService,
        private workflowStepService: WorkflowStepService,
        private workflowService: WorkflowService,
        private eventManager: JhiEventManager
    ) {
    }

    ngOnInit() {
        this.isSaving = false;
        this.authorities = ['ROLE_USER', 'ROLE_ADMIN'];
        this.workflowService.query()
            .subscribe((res: ResponseWrapper) => { this.workflows = res.json; }, (res: ResponseWrapper) => this.onError(res.json));
    }

    clear() {
        this.activeModal.dismiss('cancel');
    }

    save() {
        this.isSaving = true;
        if (this.workflowStep.id !== undefined) {
            this.subscribeToSaveResponse(
                this.workflowStepService.update(this.workflowStep));
        } else {
            this.subscribeToSaveResponse(
                this.workflowStepService.create(this.workflowStep));
        }
    }

    private subscribeToSaveResponse(result: Observable<WorkflowStep>) {
        result.subscribe((res: WorkflowStep) =>
            this.onSaveSuccess(res), (res: Response) => this.onSaveError(res));
    }

    private onSaveSuccess(result: WorkflowStep) {
        this.eventManager.broadcast({ name: 'workflowStepListModification', content: 'OK'});
        this.isSaving = false;
        this.activeModal.dismiss(result);
    }

    private onSaveError(error) {
        try {
            error.json();
        } catch (exception) {
            error.message = error.text();
        }
        this.isSaving = false;
        this.onError(error);
    }

    private onError(error) {
        this.alertService.error(error.message, null, null);
    }

    trackWorkflowById(index: number, item: Workflow) {
        return item.id;
    }
}

@Component({
    selector: 'jhi-workflow-step-popup',
    template: ''
})
export class WorkflowStepPopupComponent implements OnInit, OnDestroy {

    modalRef: NgbModalRef;
    routeSub: any;

    constructor(
        private route: ActivatedRoute,
        private workflowStepPopupService: WorkflowStepPopupService
    ) {}

    ngOnInit() {
        this.routeSub = this.route.params.subscribe((params) => {
            if ( params['id'] ) {
                this.modalRef = this.workflowStepPopupService
                    .open(WorkflowStepDialogComponent, params['id']);
            } else {
                this.modalRef = this.workflowStepPopupService
                    .open(WorkflowStepDialogComponent);
            }
        });
    }

    ngOnDestroy() {
        this.routeSub.unsubscribe();
    }
}
