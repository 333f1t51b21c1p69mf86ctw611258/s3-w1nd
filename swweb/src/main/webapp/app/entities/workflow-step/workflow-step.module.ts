import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { RouterModule } from '@angular/router';

import { SwwebSharedModule } from '../../shared';
import {
    WorkflowStepService,
    WorkflowStepPopupService,
    WorkflowStepComponent,
    WorkflowStepDetailComponent,
    WorkflowStepDialogComponent,
    WorkflowStepPopupComponent,
    WorkflowStepDeletePopupComponent,
    WorkflowStepDeleteDialogComponent,
    workflowStepRoute,
    workflowStepPopupRoute,
} from './';

import { Ng4JstreeComponent } from '../../shared';

const ENTITY_STATES = [
    ...workflowStepRoute,
    ...workflowStepPopupRoute,
];

@NgModule({
    imports: [
        SwwebSharedModule,
        RouterModule.forRoot(ENTITY_STATES, { useHash: true })
    ],
    declarations: [
        WorkflowStepComponent,
        WorkflowStepDetailComponent,
        WorkflowStepDialogComponent,
        WorkflowStepDeleteDialogComponent,
        WorkflowStepPopupComponent,
        WorkflowStepDeletePopupComponent,

        Ng4JstreeComponent
    ],
    entryComponents: [
        WorkflowStepComponent,
        WorkflowStepDialogComponent,
        WorkflowStepPopupComponent,
        WorkflowStepDeleteDialogComponent,
        WorkflowStepDeletePopupComponent,
    ],
    providers: [
        WorkflowStepService,
        WorkflowStepPopupService,
    ],
    schemas: [CUSTOM_ELEMENTS_SCHEMA]
})
export class SwwebWorkflowStepModule {}
