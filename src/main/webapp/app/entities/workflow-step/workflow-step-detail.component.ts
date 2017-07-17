import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs/Rx';
import { JhiEventManager  } from 'ng-jhipster';

import { WorkflowStep } from './workflow-step.model';
import { WorkflowStepService } from './workflow-step.service';

@Component({
    selector: 'jhi-workflow-step-detail',
    templateUrl: './workflow-step-detail.component.html'
})
export class WorkflowStepDetailComponent implements OnInit, OnDestroy {

    workflowStep: WorkflowStep;
    private subscription: Subscription;
    private eventSubscriber: Subscription;

    constructor(
        private eventManager: JhiEventManager,
        private workflowStepService: WorkflowStepService,
        private route: ActivatedRoute
    ) {
    }

    ngOnInit() {
        this.subscription = this.route.params.subscribe((params) => {
            this.load(params['id']);
        });
        this.registerChangeInWorkflowSteps();
    }

    load(id) {
        this.workflowStepService.find(id).subscribe((workflowStep) => {
            this.workflowStep = workflowStep;
        });
    }
    previousState() {
        window.history.back();
    }

    ngOnDestroy() {
        this.subscription.unsubscribe();
        this.eventManager.destroy(this.eventSubscriber);
    }

    registerChangeInWorkflowSteps() {
        this.eventSubscriber = this.eventManager.subscribe(
            'workflowStepListModification',
            (response) => this.load(this.workflowStep.id)
        );
    }
}
