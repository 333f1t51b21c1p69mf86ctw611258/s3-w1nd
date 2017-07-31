/* tslint:disable max-line-length */
import { ComponentFixture, TestBed, async, inject } from '@angular/core/testing';
import { OnInit } from '@angular/core';
import { DatePipe } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { Observable } from 'rxjs/Rx';
import { JhiDateUtils, JhiDataUtils, JhiEventManager } from 'ng-jhipster';
import { SwwebTestModule } from '../../../test.module';
import { MockActivatedRoute } from '../../../helpers/mock-route.service';
import { WorkflowStepDetailComponent } from '../../../../../../main/webapp/app/entities/workflow-step/workflow-step-detail.component';
import { WorkflowStepService } from '../../../../../../main/webapp/app/entities/workflow-step/workflow-step.service';
import { WorkflowStep } from '../../../../../../main/webapp/app/entities/workflow-step/workflow-step.model';

describe('Component Tests', () => {

    describe('WorkflowStep Management Detail Component', () => {
        let comp: WorkflowStepDetailComponent;
        let fixture: ComponentFixture<WorkflowStepDetailComponent>;
        let service: WorkflowStepService;

        beforeEach(async(() => {
            TestBed.configureTestingModule({
                imports: [SwwebTestModule],
                declarations: [WorkflowStepDetailComponent],
                providers: [
                    JhiDateUtils,
                    JhiDataUtils,
                    DatePipe,
                    {
                        provide: ActivatedRoute,
                        useValue: new MockActivatedRoute({id: 123})
                    },
                    WorkflowStepService,
                    JhiEventManager
                ]
            }).overrideTemplate(WorkflowStepDetailComponent, '')
            .compileComponents();
        }));

        beforeEach(() => {
            fixture = TestBed.createComponent(WorkflowStepDetailComponent);
            comp = fixture.componentInstance;
            service = fixture.debugElement.injector.get(WorkflowStepService);
        });

        describe('OnInit', () => {
            it('Should call load all on init', () => {
            // GIVEN

            spyOn(service, 'find').and.returnValue(Observable.of(new WorkflowStep(10)));

            // WHEN
            comp.ngOnInit();

            // THEN
            expect(service.find).toHaveBeenCalledWith(123);
            expect(comp.workflowStep).toEqual(jasmine.objectContaining({id: 10}));
            });
        });
    });

});
