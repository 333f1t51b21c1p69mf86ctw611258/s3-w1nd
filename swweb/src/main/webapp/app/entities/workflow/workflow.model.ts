import { BaseEntity } from './../../shared';

const enum WorkflowCode {
    'DECLARE_ONT_ID',
    'ACTIVATE_DEACTIVATE_ONT_ID',
    'DECLARE_PPPTP_CARD',
    'CONFIGURE_UNI_LAN_PORTS'
}

export class Workflow implements BaseEntity {
    constructor(
        public id?: number,
        public workflowCode?: WorkflowCode,
        public workflowName?: string,
        public description?: string,
        public createdBy?: number,
        public createdDate?: any,
        public lastModifiedBy?: number,
        public lastModifiedDate?: any,
        public workflowSteps?: BaseEntity[],
    ) {
    }
}
