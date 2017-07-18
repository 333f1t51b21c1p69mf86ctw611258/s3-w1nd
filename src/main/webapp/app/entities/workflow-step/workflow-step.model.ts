import { BaseEntity } from './../../shared';

const enum PropertyName {
    'ONT_INTERFACE',
    'ONT_SLOT',
    'ONT_PORT',
    'SW_VER_PLAND',
    'SW_DNLOAD_VERSION',
    'SERNUM',
    'FEC_UP',
    'ENABLE_AES',
    'PLND_VAR',
    'OPTICS_HIST',
    'BERINT',
    'PROVVERSION',
    'ADMIN_STATE',
    'PLANNED_CARD_TYPE',
    'PLNDNUMDATAPORTS',
    'PLNDNUMVOICEPORTS',
    'AUTO_DETECT'
}

const enum PropertyType {
    'STRING',
    'INTEGER'
}

export class WorkflowStep implements BaseEntity {
    constructor(
        public id?: number,
        public stepName?: string,
        public stepNumber?: number,
        public propertyName?: PropertyName,
        public propertyType?: PropertyType,
        public defaultValue?: string,
        public mapValues?: string,
        public oidPattern?: string,
        public description?: string,
        public customizedStep?: boolean,
        public setOrGet?: boolean,
        public getExpectedValue?: string,
        public createdBy?: number,
        public createdDate?: any,
        public lastModifiedBy?: number,
        public lastModifiedDate?: any,
        public workflowId?: number,
    ) {
        this.customizedStep = false;
        this.setOrGet = false;
    }
}
