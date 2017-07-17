import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { NgbActiveModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { JhiEventManager } from 'ng-jhipster';

import { WorkflowStep } from './workflow-step.model';
import { WorkflowStepPopupService } from './workflow-step-popup.service';
import { WorkflowStepService } from './workflow-step.service';

@Component({
    selector: 'jhi-workflow-step-delete-dialog',
    templateUrl: './workflow-step-delete-dialog.component.html'
})
export class WorkflowStepDeleteDialogComponent {

    workflowStep: WorkflowStep;

    constructor(
        private workflowStepService: WorkflowStepService,
        public activeModal: NgbActiveModal,
        private eventManager: JhiEventManager
    ) {
    }

    clear() {
        this.activeModal.dismiss('cancel');
    }

    confirmDelete(id: number) {
        this.workflowStepService.delete(id).subscribe((response) => {
            this.eventManager.broadcast({
                name: 'workflowStepListModification',
                content: 'Deleted an workflowStep'
            });
            this.activeModal.dismiss(true);
        });
    }
}

@Component({
    selector: 'jhi-workflow-step-delete-popup',
    template: ''
})
export class WorkflowStepDeletePopupComponent implements OnInit, OnDestroy {

    modalRef: NgbModalRef;
    routeSub: any;

    constructor(
        private route: ActivatedRoute,
        private workflowStepPopupService: WorkflowStepPopupService
    ) {}

    ngOnInit() {
        this.routeSub = this.route.params.subscribe((params) => {
            this.modalRef = this.workflowStepPopupService
                .open(WorkflowStepDeleteDialogComponent, params['id']);
        });
    }

    ngOnDestroy() {
        this.routeSub.unsubscribe();
    }
}
