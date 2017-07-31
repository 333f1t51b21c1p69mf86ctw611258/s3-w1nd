import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Response } from '@angular/http';

import { Observable } from 'rxjs/Rx';
import { NgbActiveModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { JhiEventManager, JhiAlertService } from 'ng-jhipster';

import { Workflow } from './workflow.model';
import { WorkflowPopupService } from './workflow-popup.service';
import { WorkflowService } from './workflow.service';

import {Account, Principal} from '../../shared';
import {User, UserService} from '../../shared';
import {StuffService} from '../../shared';
import {HttpClientService} from '../../shared';

@Component({
    selector: 'jhi-workflow-dialog',
    templateUrl: './workflow-dialog.component.html'
})
export class WorkflowDialogComponent implements OnInit {

    workflow: Workflow;
    isSaving: boolean;
    createdDateDp: any;
    lastModifiedDateDp: any;

    account: Account;
    user: User;

    constructor(public activeModal: NgbActiveModal,
                private alertService: JhiAlertService,
                private workflowService: WorkflowService,
                private eventManager: JhiEventManager,
                private userService: UserService,
                private principal: Principal,
                private stuffService: StuffService,
                private httpClientService: HttpClientService) {
    }

    initNewEntitty() {
        this.workflow.createdDate = this.stuffService.getCurrentDate();
        this.workflow.lastModifiedDate = this.workflow.createdDate;

        this.principal.identity().then((account) => {
            this.account = account;

            this.userService.find(this.account.login).subscribe((user) => {
                this.user = user;

                this.workflow.createdBy = this.user.id;
                this.workflow.lastModifiedBy = this.user.id;
            });
        });
    }

    onChange(event) {
        const file = event.srcElement.files;
        const postData = {field1: 'this is field1_value', field2: 'this is field2_value'}; // Put your form data variable. This is only example.
        this.httpClientService.postWithFile('/api/stepsFile', postData, file).then((result) => {
            console.log(result);
        });
    }

    ngOnInit() {
        this.isSaving = false;
        this.initNewEntitty();
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

    routeSub: any;

    constructor(
        private route: ActivatedRoute,
        private workflowPopupService: WorkflowPopupService
    ) {}

    ngOnInit() {
        this.routeSub = this.route.params.subscribe((params) => {
            if ( params['id'] ) {
                this.workflowPopupService
                    .open(WorkflowDialogComponent as Component, params['id']);
            } else {
                this.workflowPopupService
                    .open(WorkflowDialogComponent as Component);
            }
        });
    }

    ngOnDestroy() {
        this.routeSub.unsubscribe();
    }
}
