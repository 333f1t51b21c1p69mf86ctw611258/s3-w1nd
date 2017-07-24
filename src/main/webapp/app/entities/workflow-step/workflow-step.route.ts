import { Injectable } from '@angular/core';
import { Resolve, ActivatedRouteSnapshot, RouterStateSnapshot, Routes, CanActivate } from '@angular/router';

import { UserRouteAccessService } from '../../shared';
import { JhiPaginationUtil } from 'ng-jhipster';

import { WorkflowStepComponent } from './workflow-step.component';
import { WorkflowStepDetailComponent } from './workflow-step-detail.component';
import { WorkflowStepPopupComponent } from './workflow-step-dialog.component';
import { WorkflowStepDeletePopupComponent } from './workflow-step-delete-dialog.component';

export const workflowStepRoute: Routes = [
    {
        path: 'workflow-step',
        component: WorkflowStepComponent,
        data: {
            authorities: ['ROLE_USER'],
            pageTitle: 'WorkflowSteps'
        },
        canActivate: [UserRouteAccessService]
    }, {
        path: 'workflow-step/:id',
        component: WorkflowStepDetailComponent,
        data: {
            authorities: ['ROLE_USER'],
            pageTitle: 'WorkflowSteps'
        },
        canActivate: [UserRouteAccessService]
    }
];

export const workflowStepPopupRoute: Routes = [
    {
        path: 'workflow-step-new/:workflowId',
        component: WorkflowStepPopupComponent,
        data: {
            authorities: ['ROLE_USER'],
            pageTitle: 'WorkflowSteps'
        },
        canActivate: [UserRouteAccessService],
        outlet: 'popup'
    },
    {
        path: 'workflow-step/:id/edit',
        component: WorkflowStepPopupComponent,
        data: {
            authorities: ['ROLE_USER'],
            pageTitle: 'WorkflowSteps'
        },
        canActivate: [UserRouteAccessService],
        outlet: 'popup'
    },
    {
        path: 'workflow-step/:id/delete',
        component: WorkflowStepDeletePopupComponent,
        data: {
            authorities: ['ROLE_USER'],
            pageTitle: 'WorkflowSteps'
        },
        canActivate: [UserRouteAccessService],
        outlet: 'popup'
    }
];
