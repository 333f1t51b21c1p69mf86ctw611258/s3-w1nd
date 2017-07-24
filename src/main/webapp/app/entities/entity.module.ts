import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';

import { SwwebWorkflowModule } from './workflow/workflow.module';
import { SwwebWorkflowStepModule } from './workflow-step/workflow-step.module';
/* jhipster-needle-add-entity-module-import - JHipster will add entity modules imports here */

@NgModule({
    imports: [
        SwwebWorkflowModule,
        SwwebWorkflowStepModule,
        /* jhipster-needle-add-entity-module - JHipster will add entity modules here */
    ],
    declarations: [],
    entryComponents: [],
    providers: [],
    schemas: [CUSTOM_ELEMENTS_SCHEMA]
})
export class SwwebEntityModule {}
