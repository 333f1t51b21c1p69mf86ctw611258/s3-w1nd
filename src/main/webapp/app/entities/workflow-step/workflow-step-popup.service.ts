import { Injectable, Component } from '@angular/core';
import { Router } from '@angular/router';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { WorkflowStep } from './workflow-step.model';
import { WorkflowStepService } from './workflow-step.service';

@Injectable()
export class WorkflowStepPopupService {
    private isOpen = false;
    constructor(
        private modalService: NgbModal,
        private router: Router,
        private workflowStepService: WorkflowStepService

    ) {}

    open(component: Component, id?: number | any): NgbModalRef {
        if (this.isOpen) {
            return;
        }
        this.isOpen = true;

        if (id) {
            this.workflowStepService.find(id).subscribe((workflowStep) => {
                if (workflowStep.createdDate) {
                    workflowStep.createdDate = {
                        year: workflowStep.createdDate.getFullYear(),
                        month: workflowStep.createdDate.getMonth() + 1,
                        day: workflowStep.createdDate.getDate()
                    };
                }
                if (workflowStep.lastModifiedDate) {
                    workflowStep.lastModifiedDate = {
                        year: workflowStep.lastModifiedDate.getFullYear(),
                        month: workflowStep.lastModifiedDate.getMonth() + 1,
                        day: workflowStep.lastModifiedDate.getDate()
                    };
                }
                this.workflowStepModalRef(component, workflowStep);
            });
        } else {
            return this.workflowStepModalRef(component, new WorkflowStep());
        }
    }

    workflowStepModalRef(component: Component, workflowStep: WorkflowStep): NgbModalRef {
        const modalRef = this.modalService.open(component, { size: 'lg', backdrop: 'static'});
        modalRef.componentInstance.workflowStep = workflowStep;
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
