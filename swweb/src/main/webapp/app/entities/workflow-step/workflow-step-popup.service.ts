import { Injectable, Component } from '@angular/core';
import { Router } from '@angular/router';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { WorkflowStep } from './workflow-step.model';
import { WorkflowStepService } from './workflow-step.service';

@Injectable()
export class WorkflowStepPopupService {
    private ngbModalRef: NgbModalRef;

    constructor(
        private modalService: NgbModal,
        private router: Router,
        private workflowStepService: WorkflowStepService

    ) {
        this.ngbModalRef = null;
    }

    open(component: Component, id?: number | any): Promise<NgbModalRef> {
        return new Promise<NgbModalRef>((resolve, reject) => {
            const isOpen = this.ngbModalRef !== null;
            if (isOpen) {
                resolve(this.ngbModalRef);
            }

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
                    this.ngbModalRef = this.workflowStepModalRef(component, workflowStep);
                    resolve(this.ngbModalRef);
                });
            } else {
                // setTimeout used as a workaround for getting ExpressionChangedAfterItHasBeenCheckedError
                setTimeout(() => {
                    this.ngbModalRef = this.workflowStepModalRef(component, new WorkflowStep());
                    resolve(this.ngbModalRef);
                }, 0);
            }
        });
    }
    openNew(component: Component, workflowId: any): Promise<NgbModalRef> {
        return new Promise<NgbModalRef>((resolve, reject) => {
            const isOpen = this.ngbModalRef !== null;
            if (isOpen) {
                resolve(this.ngbModalRef);
            }

            const workflowStep = new WorkflowStep();
            if (workflowId === 'undefined') {
                workflowStep.workflowId = undefined;
            } else {
                workflowStep.workflowId = parseInt(workflowId, 10);
            }

            // setTimeout used as a workaround for getting ExpressionChangedAfterItHasBeenCheckedError
            setTimeout(() => {
                this.ngbModalRef = this.workflowStepModalRef(component, workflowStep);
                resolve(this.ngbModalRef);
            }, 0);
        });
    }

    workflowStepModalRef(component: Component, workflowStep: WorkflowStep): NgbModalRef {
        const modalRef = this.modalService.open(component, { size: 'lg', backdrop: 'static'});
        modalRef.componentInstance.workflowStep = workflowStep;
        modalRef.result.then((result) => {
            this.router.navigate([{ outlets: { popup: null }}], { replaceUrl: true });
            this.ngbModalRef = null;
        }, (reason) => {
            this.router.navigate([{ outlets: { popup: null }}], { replaceUrl: true });
            this.ngbModalRef = null;
        });
        return modalRef;
    }
}
