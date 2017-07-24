import { BaseEntity } from './../../shared';

const enum PropertyType {
    'STRING',
    'INTEGER'
}

export class WorkflowStep implements BaseEntity {
    constructor(
        public id?: number,
        public stepName?: string,
        public propertyName?: string,
        public stepNumber?: number,
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
