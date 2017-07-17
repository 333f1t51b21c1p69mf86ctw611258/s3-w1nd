import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Response } from '@angular/http';

import { Observable } from 'rxjs/Rx';
import { NgbActiveModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { JhiEventManager, JhiAlertService } from 'ng-jhipster';

import { Workflow } from './workflow.model';
import { WorkflowPopupService } from './workflow-popup.service';
import { WorkflowService } from './workflow.service';

@Component({
    selector: 'jhi-workflow-dialog',
    templateUrl: './workflow-dialog.component.html'
})
export class WorkflowDialogComponent implements OnInit {

    workflow: Workflow;
    authorities: any[];
    isSaving: boolean;
    createdDateDp: any;
    lastModifiedDateDp: any;

    constructor(
        public activeModal: NgbActiveModal,
        private alertService: JhiAlertService,
        private workflowService: WorkflowService,
        private eventManager: JhiEventManager
    ) {
    }

    ngOnInit() {
        this.isSaving = false;
        this.authorities = ['ROLE_USER', 'ROLE_ADMIN'];
    }

    clear() {
        this.activeModal.dismiss('cancel');
    }

    save() {
        this.isSaving = true;
        if (this.workflow.id !== undefined) {
            this.subscribeToSaveResponse(
                this.workflowService.update(this.workflow));
        } else {
            this.subscribeToSaveResponse(
                this.workflowService.create(this.workflow));
        }
    }

    private subscribeToSaveResponse(result: Observable<Workflow>) {
        result.subscribe((res: Workflow) =>
            this.onSaveSuccess(res), (res: Response) => this.onSaveError(res));
    }

    private onSaveSuccess(result: Workflow) {
        this.eventManager.broadcast({ name: 'workflowListModification', content: 'OK'});
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
}

@Component({
    selector: 'jhi-workflow-popup',
    template: ''
})
export class WorkflowPopupComponent implements OnInit, OnDestroy {

    modalRef: NgbModalRef;
    routeSub: any;

    constructor(
        private route: ActivatedRoute,
        private workflowPopupService: WorkflowPopupService
    ) {}

    ngOnInit() {
        this.routeSub = this.route.params.subscribe((params) => {
            if ( params['id'] ) {
                this.modalRef = this.workflowPopupService
                    .open(WorkflowDialogComponent, params['id']);
            } else {
                this.modalRef = this.workflowPopupService
                    .open(WorkflowDialogComponent);
            }
        });
    }

    ngOnDestroy() {
        this.routeSub.unsubscribe();
    }
}
