import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { NgbActiveModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { JhiEventManager } from 'ng-jhipster';

import { Workflow } from './workflow.model';
import { WorkflowPopupService } from './workflow-popup.service';
import { WorkflowService } from './workflow.service';

@Component({
    selector: 'jhi-workflow-delete-dialog',
    templateUrl: './workflow-delete-dialog.component.html'
})
export class WorkflowDeleteDialogComponent {

    workflow: Workflow;

    constructor(
        private workflowService: WorkflowService,
        public activeModal: NgbActiveModal,
        private eventManager: JhiEventManager
    ) {
    }

    clear() {
        this.activeModal.dismiss('cancel');
    }

    confirmDelete(id: number) {
        this.workflowService.delete(id).subscribe((response) => {
            this.eventManager.broadcast({
                name: 'workflowListModification',
                content: 'Deleted an workflow'
            });
            this.activeModal.dismiss(true);
        });
    }
}

@Component({
    selector: 'jhi-workflow-delete-popup',
    template: ''
})
export class WorkflowDeletePopupComponent implements OnInit, OnDestroy {

    modalRef: NgbModalRef;
    routeSub: any;

    constructor(
        private route: ActivatedRoute,
        private workflowPopupService: WorkflowPopupService
    ) {}

    ngOnInit() {
        this.routeSub = this.route.params.subscribe((params) => {
            this.modalRef = this.workflowPopupService
                .open(WorkflowDeleteDialogComponent, params['id']);
        });
    }

    ngOnDestroy() {
        this.routeSub.unsubscribe();
    }
}
