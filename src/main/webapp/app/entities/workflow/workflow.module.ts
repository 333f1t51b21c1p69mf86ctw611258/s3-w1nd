import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { RouterModule } from '@angular/router';

import { SwwebSharedModule } from '../../shared';
import {
    WorkflowService,
    WorkflowPopupService,
    WorkflowComponent,
    WorkflowDetailComponent,
    WorkflowDialogComponent,
    WorkflowPopupComponent,
    WorkflowDeletePopupComponent,
    WorkflowDeleteDialogComponent,
    workflowRoute,
    workflowPopupRoute,
    WorkflowResolvePagingParams,
} from './';

import { FileUploadComponent } from '../../shared';

const ENTITY_STATES = [
    ...workflowRoute,
    ...workflowPopupRoute,
];

@NgModule({
    imports: [
        SwwebSharedModule,
        RouterModule.forRoot(ENTITY_STATES, { useHash: true })
    ],
    declarations: [
        WorkflowComponent,
        WorkflowDetailComponent,
        WorkflowDialogComponent,
        WorkflowDeleteDialogComponent,
        WorkflowPopupComponent,
        WorkflowDeletePopupComponent,

        FileUploadComponent
    ],
    entryComponents: [
        WorkflowComponent,
        WorkflowDialogComponent,
        WorkflowPopupComponent,
        WorkflowDeleteDialogComponent,
        WorkflowDeletePopupComponent,
    ],
    providers: [
        WorkflowService,
        WorkflowPopupService,
        WorkflowResolvePagingParams,
    ],
    schemas: [CUSTOM_ELEMENTS_SCHEMA]
})
export class SwwebWorkflowModule {}
