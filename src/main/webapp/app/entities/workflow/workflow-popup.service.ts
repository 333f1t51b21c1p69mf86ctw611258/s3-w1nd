import { Injectable, Component } from '@angular/core';
import { Router } from '@angular/router';
import { NgbModal, NgbModalRef } from '@ng-bootstrap/ng-bootstrap';
import { Workflow } from './workflow.model';
import { WorkflowService } from './workflow.service';

@Injectable()
export class WorkflowPopupService {
    private ngbModalRef: NgbModalRef;

    constructor(
        private modalService: NgbModal,
        private router: Router,
        private workflowService: WorkflowService

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
                    this.ngbModalRef = this.workflowModalRef(component, workflow);
                    resolve(this.ngbModalRef);
                });
            } else {
                // setTimeout used as a workaround for getting ExpressionChangedAfterItHasBeenCheckedError
                setTimeout(() => {
                    this.ngbModalRef = this.workflowModalRef(component, new Workflow());
                    resolve(this.ngbModalRef);
                }, 0);
            }
        });
    }

    workflowModalRef(component: Component, workflow: Workflow): NgbModalRef {
        const modalRef = this.modalService.open(component, { size: 'lg', backdrop: 'static'});
        modalRef.componentInstance.workflow = workflow;
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
