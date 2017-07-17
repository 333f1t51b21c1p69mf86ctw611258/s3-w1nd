import { Injectable, Component } from '@angular/core';
import { Router } from '@angular/router';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { Workflow } from './workflow.model';
import { WorkflowService } from './workflow.service';

@Injectable()
export class WorkflowPopupService {
    private isOpen = false;
    constructor(
        private modalService: NgbModal,
        private router: Router,
        private workflowService: WorkflowService

    ) {}

    open(component: Component, id?: number | any): NgbModalRef {
        if (this.isOpen) {
            return;
        }
        this.isOpen = true;

        if (id) {
            this.workflowService.find(id).subscribe((workflow) => {
                if (workflow.createdDate) {
                    workflow.createdDate = {
                        year: workflow.createdDate.getFullYear(),
                        month: workflow.createdDate.getMonth() + 1,
                        day: workflow.createdDate.getDate()
                    };
                }
                if (workflow.lastModifiedDate) {
                    workflow.lastModifiedDate = {
                        year: workflow.lastModifiedDate.getFullYear(),
                        month: workflow.lastModifiedDate.getMonth() + 1,
                        day: workflow.lastModifiedDate.getDate()
                    };
                }
                this.workflowModalRef(component, workflow);
            });
        } else {
            return this.workflowModalRef(component, new Workflow());
        }
    }

    workflowModalRef(component: Component, workflow: Workflow): NgbModalRef {
        const modalRef = this.modalService.open(component, { size: 'lg', backdrop: 'static'});
        modalRef.componentInstance.workflow = workflow;
        modalRef.result.then((result) => {
            this.router.navigate([{ outlets: { popup: null }}], { replaceUrl: true });
            this.isOpen = false;
        }, (reason) => {
            this.router.navigate([{ outlets: { popup: null }}], { replaceUrl: true });
            this.isOpen = false;
        });
        return modalRef;
    }
}
