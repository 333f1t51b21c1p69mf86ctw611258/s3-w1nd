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

import { Account, Principal } from '../../shared';
import { User, UserService } from '../../shared';
import { StuffService } from '../../shared';

@Component({
    selector: 'jhi-workflow-step-dialog',
    templateUrl: './workflow-step-dialog.component.html'
})
export class WorkflowStepDialogComponent implements OnInit {

    workflowStep: WorkflowStep;
    isSaving: boolean;

    workflows: Workflow[];
    createdDateDp: any;
    lastModifiedDateDp: any;

    account: Account;
    user: User;

    constructor(
        public activeModal: NgbActiveModal,
        private alertService: JhiAlertService,
        private workflowStepService: WorkflowStepService,
        private workflowService: WorkflowService,
        private eventManager: JhiEventManager,

        private userService: UserService,
        private principal: Principal,
        private stuffService: StuffService
    ) {
    }

    initNewEntity() {
        this.workflowStep.createdDate = this.stuffService.getCurrentDate();
        this.workflowStep.lastModifiedDate = this.workflowStep.createdDate;

        this.principal.identity().then((account) => {
            this.account = account;

            this.userService.find(this.account.login).subscribe((user) => {
                this.user = user;

                this.workflowStep.createdBy = this.user.id;
                this.workflowStep.lastModifiedBy = this.user.id;
            });
        });

        if (this.workflowStep.workflowId !== undefined) {
            this.workflowStepService.queryCountByWorkflowId(this.workflowStep.workflowId)
                .subscribe((res: ResponseWrapper) => {

                        this.workflowStep.stepNumber = parseInt(res.json, 10) + 1;

                    }, (res: ResponseWrapper) => this.onError(res.json));
        }
    }

    initWorkflowStep() {
        this.workflowStepService.initByStepName(this.workflowStep.stepName).subscribe((res: WorkflowStep) => {
            this.workflowStep.propertyType = res.propertyType;
            this.workflowStep.oidPattern = res.oidPattern;
        }, (res: ResponseWrapper) => this.onError(res.json));
    }

    ngOnInit() {
        this.isSaving = false;
        this.workflowService.query()
            .subscribe((res: ResponseWrapper) => { this.workflows = res.json; }, (res: ResponseWrapper) => this.onError(res.json));

        if (this.workflowStep.id === undefined) {
            this.initNewEntity();
        }
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

    routeSub: any;

    constructor(
        private route: ActivatedRoute,
        private workflowStepPopupService: WorkflowStepPopupService
    ) {}

    ngOnInit() {
        this.routeSub = this.route.params.subscribe((params) => {
            if ( params['workflowId'] && (typeof params['workflowId'] !== 'undefined') ) {
                this.workflowStepPopupService
                    .openNew(WorkflowStepDialogComponent as Component, params['workflowId']);
            } else {
                if ( params['id'] ) {
                    this.workflowStepPopupService
                        .open(WorkflowStepDialogComponent as Component, params['id']);
                } else {
                    this.workflowStepPopupService
                        .open(WorkflowStepDialogComponent as Component);
                }
            }
        });
    }

    ngOnDestroy() {
        this.routeSub.unsubscribe();
    }
}
